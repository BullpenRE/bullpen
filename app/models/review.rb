class Review < ApplicationRecord
  belongs_to :employer_profile
  belongs_to :freelancer_profile

  validate :between_different_parties
  validates :rating, inclusion: { in: 1..5, message: 'Must be between 1 and 5' }, allow_nil: true
  validates :freelancer_profile_id, uniqueness: { scope: :employer_profile_id }

  def between_different_parties
    return unless freelancer_profile.user_id == employer_profile.user_id

    errors.add(:to_user_id, "can't review yourself")
  end
end
