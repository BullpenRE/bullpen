# frozen_string_literal: true

class Skill < ApplicationRecord
  default_scope { enabled.order(description: :asc) }
  scope :enabled, -> { where.not(disable: true) }

  has_many :job_skills, dependent: :destroy
  has_many :jobs, through: :job_skills
  validates :description, presence: true, uniqueness: true
end
