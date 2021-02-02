# frozen_string_literal: true

class Job < ApplicationRecord
  include Slugable

  belongs_to :user
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

  validates :user_id, presence: true
  scope :not_applied_or_withdrawn, lambda { |user|
    where.not(id: user.job_applications.pluck(:job_id))
         .or(where(id: user.job_applications.withdrawn.pluck(:job_id)))
  }
  validate :pay_ranges_make_sense

  enum position_length: { 'long-term': 0, 'temporary': 1 }
  enum hours_needed: { 'part-time': 0, 'on-call': 1, 'project-based': 2 }
  enum required_experience: { 'junior': 0, 'intermediate': 1, 'senior': 2 }
  enum time_zone: { 'HST': 0, 'AKST': 1, 'PST': 2, 'MST': 3, 'CST': 4, 'EST': 5 }
  enum state: { 'draft': 0, 'posted': 1, 'closed': 2 }
  enum contract_type: { 'hourly': 0, 'monthly_retainer_20': 1, 'monthly_retainer_40': 2, 'monthly_retainer_80': 3 }

  CONTRACT_TYPE_DESCRIPTIONS = {
    'Hourly': contract_types.keys[0],
    'Monthly Retainer - 20 hrs': contract_types.keys[1],
    'Monthly Retainer - 40 hrs': contract_types.keys[2],
    'Monthly Retainer - 80 hrs': contract_types.keys[3]
  }.freeze

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
    errors.add(:pay_range_high, 'must be blank for retainer type contracts') if pay_range_high_present_for_retainers?
  end

  def high_range_lesser_than_low_range?
    !pay_range_high.nil? && !pay_range_low.nil? && pay_range_high < pay_range_low
  end

  def pay_range_high_present_for_retainers?
    contract_type != 'hourly' && !pay_range_high.nil?
  end
end
