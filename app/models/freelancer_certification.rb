class FreelancerCertification < ApplicationRecord
  belongs_to :freelancer_profile
  belongs_to :certification
  has_one :user, through: :freelancer_profile

  validates :description, presence: true, uniqueness: { scope: :freelancer_profile_id }

  AVAILABLE_YEARS = (40.years.ago.year..Time.now.year).reverse_each
end
