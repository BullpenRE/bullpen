# frozen_string_literal: true

class JobApplication < ApplicationRecord
  belongs_to :user
  belongs_to :job
  has_many :job_application_questions, dependent: :destroy
  has_one_attached :work_sample

  validates :job_id, uniqueness: { scope: :user_id }
  validate :correct_size?
  validates :per_hour_bid, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  enum state: { 'draft': 0, 'applied': 1, 'withdrawn': 2 }

  MAX_FILE_SIZE = 20_971_520

  def correct_size?
    return true if attachment_valid_correct_size?(work_sample)

    errors.add(:base, 'Uploaded files must not exceed 20MB.')
    false
  end

  def attachment_valid_correct_size?(attachment)
    return true if no_attachment_uploaded?(attachment)
    return true if attachment.blob.byte_size < MAX_FILE_SIZE

    false
  end

  def no_attachment_uploaded?(attachment)
    attachment.attached? == false
  end
end
