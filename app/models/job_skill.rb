# frozen_string_literal: true

class JobSkill < ApplicationRecord
  belongs_to :job
  belongs_to :skill

  validates :job_id, uniqueness: { scope: :skill_id }
end
