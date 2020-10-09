class FreelancerProfileExperience < ApplicationRecord
  belongs_to :freelancer_profile

  validates :job_title, presence: true
  validates :company, presence: true
  validates :location, presence: true
  validates :start_date, presence: true
  validates :description, presence: true
end
