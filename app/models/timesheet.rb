# frozen_string_literal: true

class Timesheet < ApplicationRecord
  belongs_to :contract
  has_many :billings, dependent: :nullify

  validates :starts, :ends, presence: true
  validate :ends_after_start

  default_scope { order(ends: :desc) }

  scope :related_to_contracts, lambda { |contracts_ids|
    where(contract_id: contracts_ids)
  }
  scope :ready_for_payment, lambda {
    where(Timesheet.arel_table[:stripe_id_invoice].eq(nil).and(Timesheet.arel_table[:ends]).lteq(Date.current))
  }
  scope :paid, -> { where.not(stripe_id_invoice: nil) }

  def title(employer)
    return 'Current Hours' if ends >= Date.current
    return "Payment Paused - <span style='color: red'>Disputed</span>".html_safe if disputed?
    return 'Payment Paused' if paused?
    return "Payment Due on #{pending_payment_date.strftime('%b %e')}" if employer

    "Pending Payment on #{pending_payment_date.strftime('%b %e')}"
  end

  def total_hours_display
    unpaid_billing_total_hours.round(2)
  end

  def total_usd
    (contract.pay_rate * unpaid_billing_total_hours).round(2)
  end

  def dispute_deadline
    (pending_payment_date - 1.day).strftime('%b %e')
  end

  def pending_payment_date
    ends.next_occurring(:friday)
  end

  def disputed?
    billings.where(state: 'disputed').present? && pending_payment_date > Date.current
  end

  def employer_total_charge
    billings.pending.sum(&:multiplier) * contract.pay_rate
  end

  private

  def ends_after_start
    errors.add(:ends, 'must be after the start date') if starts.to_s > ends.to_s
  end

  def paused?
    billings.where(state: 'disputed').present? && pending_payment_date < Date.current
  end

  def unpaid_billing_total_hours
    billings.not_paid.sum('hours') + billings.not_paid.sum('minutes') / 60.0
  end
end
