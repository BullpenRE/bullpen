class FreelancerSoftware < ApplicationRecord
  belongs_to :freelancer_profile
  belongs_to :software

  validates :freelancer_profile_id, uniqueness: { scope: :software_id }
end
