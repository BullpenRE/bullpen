# frozen_string_literal: true

class Job < ApplicationRecord
  belongs_to :user
  has_many :job_skills, dependent: :destroy
  has_many :skills, through: :job_skills
  has_many :job_softwares, dependent: :destroy
  has_many :softwares, through: :job_softwares
  has_many :job_sectors, dependent: :destroy
  has_many :sectors, through: :job_sectors
  has_many :job_questions, dependent: :destroy
  has_many :job_applications, dependent: :destroy

  validates :user_id, presence: true
  validate :pay_ranges_make_sense

  enum position_length: { 'long-term': 0, 'temporary': 1 }
  enum hours_needed: { 'part-time': 0, 'on-call': 1, 'project-based': 2 }
  enum required_experience: { 'junior': 0, 'intermediate': 1, 'senior': 2 }
  enum time_zone: { 'HST': 0, 'AKST': 1, 'PST': 2, 'MST': 3, 'CST': 4, 'EST': 5 }
  enum state: { 'draft': 0, 'posted': 1, 'closed': 2 }
  enum contract_type: { 'hourly': 0, 'monthly_retainer_80': 1 }

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
    errors.add(:pay_range_high, 'must be higher than pay range low') if !pay_range_high.nil? && !pay_range_low.nil? && pay_range_high < pay_range_low
    errors.add(:pay_range_low, 'must be greater than 0') if !pay_range_low.nil? && pay_range_low < 0
    errors.add(:pay_range_high, 'must be greater than 0') if !pay_range_high.nil? && pay_range_high < 0
  end
end
