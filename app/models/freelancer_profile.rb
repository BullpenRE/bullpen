# frozen_string_literal: true

class FreelancerProfile < ApplicationRecord
  belongs_to :user
  has_many :freelancer_asset_classes, dependent: :destroy
  has_many :freelancer_real_estate_skills, dependent: :destroy
  has_many :freelancer_profile_experiences, dependent: :destroy
  has_many :freelancer_profile_educations, dependent: :destroy
  has_one_attached :avatar

  enum professional_years_experience: ['0-2', '2-5', '5-10', '>10']

  MAX_FILE_SIZE = 2_097_152
  ACCEPTABLE_CONTENT_TYPE = %w[image/jpg image/jpeg image/png image/gif].freeze

  validate :correct_content_type?, :correct_size?

  private

  def correct_content_type?
    return true if attachment_valid_content_type?(avatar)

    errors.add(:base, 'Please upload only a jpg, png or gif image.')
    false
  end

  def correct_size?
    return true if attachment_valid_correct_size?(avatar)

    errors.add(:base, 'Uploaded files must not exceed 2MB.')
    false
  end

  def attachment_valid_content_type?(attachment)
    return true unless attachment.attached?
    return true if ACCEPTABLE_CONTENT_TYPE.include?(attachment.blob.content_type)
    return true if attachment.blob.content_type.blank?

    false
  end

  def attachment_valid_correct_size?(attachment)
    return true unless attachment.attached?
    return true if attachment.blob.byte_size < MAX_FILE_SIZE

    false
  end
end
