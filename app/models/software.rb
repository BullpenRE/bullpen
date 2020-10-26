# frozen_string_literal: true

class Software < ApplicationRecord
  has_many :job_softwares, dependent: :destroy
  has_many :jobs, through: :job_softwares
  validates :description, presence: true, uniqueness: true
end
