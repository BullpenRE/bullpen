# frozen_string_literal: true

class Sector < ApplicationRecord
  has_many :freelancer_sectors, dependent: :destroy
  has_many :freelancer_profiles, through: :freelancer_sectors
  has_many :job_sectors, dependent: :destroy
  has_many :jobs, through: :job_sectors
  has_many :employer_sectors, dependent: :destroy
  has_many :employer_profiles, through: :employer_sectors

  validates :description, presence: true, uniqueness: true
end
