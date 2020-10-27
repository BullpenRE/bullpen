# frozen_string_literal: true

class Skill < ApplicationRecord
  has_many :job_skills, dependent: :destroy
  has_many :jobs, through: :job_skills
  validates :description, presence: true, uniqueness: true
end
