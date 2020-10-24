# frozen_string_literal: true

class Job < ApplicationRecord
  belongs_to :user
  has_many :job_sectors, dependent: :destroy
  has_many :sectors, through: :job_sectors
  has_many :job_skills, dependent: :destroy
  has_many :skills, through: :job_skills
  has_many :job_questions, dependent: :destroy

  validates :user_id, presence: true

  enum position_length: { 'long-term': 0, 'temporary': 1 }
  enum required_experience: { 'junior': 0, 'intermediate': 1, 'senior': 2 }
end
