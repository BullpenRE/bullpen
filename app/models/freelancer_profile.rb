# frozen_string_literal: true

class FreelancerProfile < ApplicationRecord
  belongs_to :user
  has_many :freelancer_asset_classes, dependent: :destroy
  has_many :freelancer_real_estate_skills, dependent: :destroy

  enum professional_years_experience: ['0-2', '2-5', '5-10', '>10']
end
