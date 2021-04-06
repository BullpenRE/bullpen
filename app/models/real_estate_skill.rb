# frozen_string_literal: true

class RealEstateSkill < ApplicationRecord
  default_scope { order(description: :asc) }
  scope :enabled, -> { where.not(disable: true) }

  validates :description, presence: true, uniqueness: true
  has_many :freelancer_real_estate_skills, dependent: :destroy
  has_many :freelancer_profiles, through: :freelancer_real_estate_skills
end
