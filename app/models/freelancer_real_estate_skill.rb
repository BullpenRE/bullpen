# frozen_string_literal: true

class FreelancerRealEstateSkill < ApplicationRecord
  belongs_to :freelancer_profile, foreign_key: :freelancer_profiles_id
  belongs_to :real_estate_skill, foreign_key: :real_estate_skills_id

  validates :freelancer_profiles_id, uniqueness: { scope: :real_estate_skills_id }
end
