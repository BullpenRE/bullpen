# frozen_string_literal: true

class Billing < ApplicationRecord
  belongs_to :contract
  enum state: { pending: 0, disputed: 1, paid: 2 }
  scope :resolved, -> { where(state: 'pending').where.not(dispute_resolved: nil) }

  validates :hours, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :minutes, allow_nil: true, numericality: { greater_than_or_equal_to: 0, less_than: 60 }

  def multiplier
    hours.to_i + (minutes / 60.0)
  end
end
