# frozen_string_literal: true

class JobQuestion < ApplicationRecord
  belongs_to :job
  has_many :job_application_questions, dependent: :destroy

  validates :description, presence: true, uniqueness: { scope: :job_id }
end
