# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :employer_profile
  belongs_to :freelancer_profile

  RATING_OPTIONS = (1..5).freeze
  validate :between_different_parties
  validates :rating, inclusion: { in: RATING_OPTIONS, message: 'Must be between 1 and 5' }, allow_nil: true
  validates :freelancer_profile_id, uniqueness: { scope: :employer_profile_id }

  scope :commented, -> { where.not(comments: [nil, '']).order(updated_at: :desc) }

  def between_different_parties
    return unless freelancer_profile.user_id == employer_profile.user_id

    errors.add(:to_user_id, "can't review yourself")
  end

  def equal_rating?(review_rating)
    rating == review_rating
  end
end
