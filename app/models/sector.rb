class Sector < ApplicationRecord
  has_many :job_sectors, dependent: :destroy
  has_many :jobs, through: :job_sectors
  validates :description, presence: true, uniqueness: true
end
