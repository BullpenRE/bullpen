# frozen_string_literal: true

class FreelancerProfile < ApplicationRecord
  belongs_to :user
  has_many :freelancer_asset_classes, dependent: :destroy
  has_many :freelancer_real_estate_skills, dependent: :destroy
end
