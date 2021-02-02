# frozen_string_literal: true

class FreelancerProfile < ApplicationRecord
  include Slugable

  belongs_to :user
  has_many :freelancer_real_estate_skills, dependent: :destroy
  has_many :real_estate_skills, through: :freelancer_real_estate_skills
  has_many :freelancer_profile_experiences, dependent: :destroy
  has_many :freelancer_profile_educations, dependent: :destroy
  has_many :freelancer_sectors, dependent: :destroy
  has_many :sectors, through: :freelancer_sectors
  has_many :freelancer_softwares, dependent: :destroy
  has_many :softwares, through: :freelancer_softwares
  has_many :freelancer_certifications, dependent: :destroy
  has_many :interview_requests, dependent: :destroy
  has_one_attached :avatar

  scope :users, -> { joins(:user) }

  enum professional_years_experience: { '0-2': 0, '2-5': 1, '5-10': 2, '>10': 3 }
  enum curation: { pending: 0, declined: 1, accepted: 2 }

  validates :slug, uniqueness: true
  validates :desired_hourly_rate, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }

  scope :searchable, -> { where(searchable: true) }

  def ready_for_submission?
    draft? && pending?
  end

  def first_name
    @first_name ||= user.first_name
  end

  def last_name
    @last_name ||= user.last_name
  end

  def full_name
    @full_name ||= user.full_name
  end

  def email
    @email ||= user.email
  end

  def location
    @location ||= user.location
  end

  def editable?(user)
    user_id == user&.id
  end

  def interview_request(employer_profile)
    interview_requests.find_by(employer_profile: employer_profile)
  end
end
