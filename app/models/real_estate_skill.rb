# frozen_string_literal: true

class RealEstateSkill < ApplicationRecord
  validates :description, presence: true, uniqueness: true
  has_many :freelancer_real_estate_skills
end
