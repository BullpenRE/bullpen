# frozen_string_literal: true

class Sector < ApplicationRecord
  validates :sector_description, presence: true, uniqueness: true
  has_many :employer_profile_sectors
end
