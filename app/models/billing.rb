# frozen_string_literal: true

class Billing < ApplicationRecord
  belongs_to :contract
  belongs_to :timesheet, optional: true
  enum state: { pending: 0, disputed: 1, paid: 2 }
  scope :resolved, -> { where(state: 'pending').where.not(dispute_resolved: nil) }

  validates :hours, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :minutes, allow_nil: true, numericality: { greater_than_or_equal_to: 0, less_than: 60 }
  validate :must_have_some_time_entered, :same_contract_as_timesheet

  def multiplier
    hours.to_i + (minutes.to_i / 60.0)
  end

  private

  def must_have_some_time_entered
    errors.add(:hours, 'no time was entered for the billing entry') unless multiplier > 0.0
  end

  def same_contract_as_timesheet
    return unless timesheet_id

    errors.add(:contract_id, 'contract is different than its timesheet') if timesheet.contract_id != contract_id
  end
end
