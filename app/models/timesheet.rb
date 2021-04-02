# frozen_string_literal: true

class Timesheet < ApplicationRecord
  default_scope { order(ends: :desc) }
  belongs_to :contract
  has_many :billings, dependent: :nullify
  validates :starts, :ends, presence: true
  validate :ends_after_start

  def title
    return 'Current Hours' if ends > Date.current
    return "Payment Paused - <span style='color: red'>Disputed</span>".html_safe if disputed?
    return 'Payment Paused' if paused?

    "Pending Payment on #{pending_payment_date.strftime('%b %e')}"
  end

  private

  def ends_after_start
    errors.add(:ends, 'must be after the start date') if starts.to_s > ends.to_s
  end

  def pending_payment_date
    ends.next_occurring(:friday)
  end

  def disputed?
    billings.where(state: 'disputed').present? && pending_payment_date > Date.current
  end

  def paused?
    billings.where(state: 'disputed').present? && pending_payment_date < Date.current
  end
end
