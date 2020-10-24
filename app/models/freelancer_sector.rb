# frozen_string_literal: true

class FreelancerSector < ApplicationRecord
  belongs_to :freelancer_profile
  belongs_to :sector

  validates :freelancer_profile_id, uniqueness: { scope: :sector_id }
end
