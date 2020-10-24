# frozen_string_literal: true

class JobQuestion < ApplicationRecord
  belongs_to :job

  validates :description, presence: true, uniqueness: { scope: :job_id }
end
