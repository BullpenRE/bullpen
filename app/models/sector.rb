# frozen_string_literal: true

class Sector < ApplicationRecord
  validates :description, presence: true, uniqueness: true
  has_many :freelancer_sectors, dependent: :destroy
  has_many :freelancer_profiles, through: :freelancer_sectors
  has_many :job_sectors, dependent: :destroy
  has_many :jobs, through: :job_sectors
end
