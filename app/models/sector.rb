# frozen_string_literal: true

class Sector < ApplicationRecord
  validates :description, presence: true, uniqueness: true
  has_many :freelancer_sectors, dependent: :destroy
  has_many :freelancer_profiles, through: :freelancer_sectors
end
