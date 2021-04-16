# frozen_string_literal: true

class Job < ApplicationRecord
  include Slugable

  belongs_to :employer_profile
  has_many :job_skills, dependent: :destroy
  has_many :skills, through: :job_skills
  has_many :job_softwares, dependent: :destroy
  has_many :softwares, through: :job_softwares
  has_many :job_sectors, dependent: :destroy
  has_many :sectors, through: :job_sectors
  has_many :job_questions, dependent: :destroy
  has_many :job_applications, dependent: :destroy
  has_many :contracts, dependent: :nullify
  has_rich_text :relevant_details

  scope :not_applied_or_withdrawn, lambda { |freelancer_profile|
    where.not(id: freelancer_profile.job_applications.pluck(:job_id))
         .or(where(id: freelancer_profile.job_applications.withdrawn.pluck(:job_id)))
  }
  scope :ready_for_announcement, -> { where(state: 'posted', job_announced: false) }
  scope :employer_enabled, -> { where(employer_profile_id: EmployerProfile.user_enabled.ids) }
  validate :pay_ranges_make_sense
  validates :employer_profile_id, presence: true

  enum position_length: { 'long-term': 0, 'temporary': 1 }
  enum hours_needed: { 'part-time': 0, 'on-call': 1, 'project-based': 2 }
  enum required_experience: { 'junior': 0, 'intermediate': 1, 'senior': 2 }
  enum time_zone: { 'HST': 0, 'AKST': 1, 'PST': 2, 'MST': 3, 'CST': 4, 'EST': 5 }
  enum state: { 'draft': 0, 'posted': 1, 'closed': 2, 'edit': 3 }
  enum contract_type: { 'hourly': 0 }

  def ready_to_post?
    title.present? &&
      short_description.present? &&
      sectors.present? &&
      position_length.present? &&
      hours_needed.present? &&
      required_experience.present? &&
      job_skills.present?
  end

  private

  def pay_ranges_make_sense
    errors.add(:pay_range_high, 'must be higher than pay range low') if high_range_lesser_than_low_range?
    errors.add(:pay_range_low, 'must be greater than 0') if pay_range_low&.negative?
    errors.add(:pay_range_high, 'must be greater than 0') if pay_range_high&.negative?
  end

  def high_range_lesser_than_low_range?
    !pay_range_high.nil? && !pay_range_low.nil? && pay_range_high < pay_range_low
  end
end
