class JobSoftware < ApplicationRecord
  belongs_to :job
  belongs_to :software

  validates :job_id, uniqueness: { scope: :software_id }
end
