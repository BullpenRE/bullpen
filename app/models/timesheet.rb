class Timesheet < ApplicationRecord
  belongs_to :contract
  has_many :billings, dependent: :nullify
  validates :starts, :ends, presence: true
  validate :ends_after_start

  private

  def ends_after_start
    errors.add(:ends, 'must be after the start date') if starts.to_s > ends.to_s
  end
end
