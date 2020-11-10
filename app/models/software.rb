# frozen_string_literal: true

class Software < ApplicationRecord
  has_many :job_softwares, dependent: :destroy
  has_many :jobs, through: :job_softwares
  has_many :freelancer_softwares, dependent: :destroy
  has_many :freelancer_profiles, through: :freelancer_softwares

  validates :description, presence: true, uniqueness: true
end
