class FreelancerCertification < ApplicationRecord
  belongs_to :freelancer_profile
  belongs_to :certification
  has_one :user, through: :freelancer_profile

  validates :description, presence: true, uniqueness: { scope: :freelancer_profile_id }
end
