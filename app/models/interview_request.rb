# frozen_string_literal: true

class InterviewRequest < ApplicationRecord
  belongs_to :employer_profile
  belongs_to :freelancer_profile
  has_rich_text :message
  scope :not_rejected, -> { where(state: %w[pending accepted]) }
  scope :freelancer_visible, -> { where.not(hide_from_freelancer: true) }
  scope :employer_visible, -> { where.not(hide_from_employer: true) }

  enum state: { 'pending': 0, 'accepted': 1, 'withdrawn': 2, 'declined': 3 }

  validates :employer_profile_id, uniqueness: { scope: :freelancer_profile_id }
end
