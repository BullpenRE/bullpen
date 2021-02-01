# frozen_string_literal: true

class JobApplicationQuestion < ApplicationRecord
  belongs_to :job_application
  belongs_to :job_question

  validates :job_application_id, uniqueness: { scope: :job_question_id }
  validates :answer, presence: true
end
