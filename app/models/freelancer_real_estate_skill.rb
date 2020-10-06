# frozen_string_literal: true

class FreelancerRealEstateSkill < ApplicationRecord
  belongs_to :freelancer_profile
  belongs_to :real_estate_skill

  validates :freelancer_profile_id, uniqueness: { scope: :real_estate_skill_id }
end
