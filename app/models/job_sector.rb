# frozen_string_literal: true

class JobSector < ApplicationRecord
  belongs_to :job
  belongs_to :sector

  validates :job_id, uniqueness: { scope: :sector_id }
end
