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
  has_many :contracts, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :job_applications, dependent: :destroy
  has_one_attached :avatar

  scope :users, -> { joins(:user) }

  enum professional_years_experience: { '0-2': 0, '2-5': 1, '5-10': 2, '>10': 3 }
  enum curation: { pending: 0, declined: 1, accepted: 2 }

  validates :slug, uniqueness: true
  validates :desired_hourly_rate, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :payout_percentage, allow_nil: false, inclusion: { in: 0..100, message: 'must be between 0-100' }

  scope :searchable, -> { where(searchable: true) }
  scope :ready_for_announcement, -> { where(curation: 'accepted', new_jobs_alert: true) }

  def ready_for_submission?
    draft? && pending?
  end

  def review_from(employer_profile)
    @review_from ||= {}
    @review_from[employer_profile.id] ||= reviews.find_by(employer_profile: employer_profile)
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

  def average_rating
    return nil unless reviews.any?

    @average_rating ||= (reviews.sum(:rating) / reviews.size.to_f).round(1)
  end

  def can_request_interview?(employer_profile_id)
    @can_request_interview ||= interview_requests.not_rejected.find_by(employer_profile_id: employer_profile_id).blank?
  end
end
