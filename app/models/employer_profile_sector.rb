# frozen_string_literal: true

class EmployerProfileSector < ApplicationRecord
  belongs_to :employer_profile
  belongs_to :sector

  validates :employer_profile_id, uniqueness: { scope: :sector_id }
end