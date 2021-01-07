# frozen_string_literal: true

class JobApplication < ApplicationRecord
  belongs_to :user
  belongs_to :job
  has_many :job_application_questions, dependent: :destroy
  has_many :job_questions, through: :job_application_questions
  has_many_attached :work_samples
  has_rich_text :cover_letter

  validates :job_id, uniqueness: { scope: :user_id }
  validate :correct_size?
  validates :per_hour_bid, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  enum state: { 'draft': 0, 'applied': 1, 'withdrawn': 2 }

  after_save :update_other_user_job_application_templates
  after_create :update_other_user_job_application_templates

  MAX_FILE_SIZE = 20_971_520

  def correct_size?
    return true if attachment_valid_correct_size?(work_samples)

    errors.add(:base, 'Uploaded files must not exceed 20MB.')
    false
  end

  def attachment_valid_correct_size?(attachment)
    return true if attachment.blobs[0].blank?
    return true if attachment.blobs[0].byte_size < MAX_FILE_SIZE

    false
  end

  private

  def update_other_user_job_application_templates
    user.job_applications.where.not(id: id).update_all(template: false) if template?
  end
end
