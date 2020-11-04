class Certification < ApplicationRecord
  has_many :freelancer_certifications
  has_many :freelancer_profiles, through: :freelancer_certifications
  scope :searchable, -> { where(custom: false) }

  validate :blank_descriptions
  validates :description, uniqueness: true

  private
  
  def blank_descriptions
    if custom?
      errors.add(:description, 'for custom must be blank') if description.present?
    else
      errors.add(:description, 'for non-custom must be present') if description.blank?
    end
  end
end
