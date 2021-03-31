# frozen_string_literal: true

class Timesheet < ApplicationRecord
  belongs_to :contract
  has_many :billings, dependent: :nullify
  validates :starts, :ends, presence: true
  validate :ends_after_start

  def title
    return 'Current Hours' if ends > Date.current

    "Pending Payment on #{pending_payment_date.strftime('%b %e')}"
  end

  private

  def ends_after_start
    errors.add(:ends, 'must be after the start date') if starts.to_s > ends.to_s
  end

  def pending_payment_date
    ends.next_occurring(:friday)
  end
end
