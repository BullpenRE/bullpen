# frozen_string_literal: true

class JobApplication < ApplicationRecord
  MAX_FILE_SIZE = 20_971_520
  MAX_WORK_SAMPLES_COUNT = 10

  belongs_to :user
  belongs_to :job
  has_many :job_application_questions, dependent: :destroy
  has_many :job_questions, through: :job_application_questions
  has_many_attached :work_samples
  has_rich_text :cover_letter

  attr_accessor :job_application_id, :step

  validates :job_id, uniqueness: { scope: :user_id }
  validates :work_samples,
            limit: { min: 0, max: MAX_WORK_SAMPLES_COUNT, message: "quantity must be #{MAX_WORK_SAMPLES_COUNT} or less" }
  validates :work_samples, size: { less_than: MAX_FILE_SIZE, message: 'must be less than 20MB in size' }
  validates :per_hour_bid, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  enum state: { 'draft': 0, 'applied': 1, 'withdrawn': 2 }

  after_save :update_other_user_job_application_templates
  after_create :update_other_user_job_application_templates

  def adding_work_samples_allowed?
    work_samples.size < MAX_WORK_SAMPLES_COUNT
  end

  private

  def update_other_user_job_application_templates
    user.job_applications.where.not(id: id).update_all(template: false) if template?
  end
end
