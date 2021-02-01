# frozen_string_literal: true

class Certification < ApplicationRecord
  has_many :freelancer_certifications, dependent: :destroy
  has_many :freelancer_profiles, through: :freelancer_certifications
  scope :searchable, -> { where(custom: false) }
  scope :enabled, -> { where.not(disable: true) }

  validate :blank_descriptions
  validates :description, uniqueness: true

  def self.custom_id
    Certification.find_by(custom: true)&.id
  end

  private

  def blank_descriptions
    if custom?
      errors.add(:description, 'for custom must be blank') if description.present?
    elsif description.blank?
      errors.add(:description, 'for non-custom must be present')
    end
  end
end
