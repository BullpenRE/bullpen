class FreelancerRealEstateSkill < ApplicationRecord
  validates :freelancers_id, uniqueness: { scope: :real_estate_skills_id }
end
