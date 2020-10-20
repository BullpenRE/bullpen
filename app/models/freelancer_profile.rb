# frozen_string_literal: true

class FreelancerProfile < ApplicationRecord
  belongs_to :user
  has_many :freelancer_asset_classes, dependent: :destroy
  has_many :freelancer_real_estate_skills, dependent: :destroy
  has_many :freelancer_profile_experiences, dependent: :destroy
  has_many :freelancer_profile_educations, dependent: :destroy

  has_many :asset_classes, through: :freelancer_asset_classes
  has_many :real_estate_skills, through: :freelancer_real_estate_skills

  enum professional_years_experience: ['0-2', '2-5', '5-10', '>10']
end
