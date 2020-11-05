# frozen_string_literal: true

class FreelancerProfileExperience < ApplicationRecord
  belongs_to :freelancer_profile

  validates :job_title, presence: true
  validates :company, presence: true
  validates :location, presence: true
  validates :description, presence: true

  AVAILABLE_YEARS = (1991..Time.now.year).reverse_each
  AVAILABLE_MONTHNAMES = Date::MONTHNAMES.each_with_index.collect { |m, i| [m, i] }.drop(1)

  before_save :update_start_date, :update_end_date
  attr_accessor :start_month, :start_year, :end_month, :end_year

  def update_start_date
    return unless start_year.present? && start_month.present?

    start_date = "#{start_year}-#{start_month}"
    self.start_date = Date.strptime(start_date, '%Y-%m')
  end

  def update_end_date
    return unless end_year.present? && end_month.present?

    end_date = "#{end_year}-#{end_month}"
    self.end_date = Date.strptime(end_date, '%Y-%m')
  end

  def description_paragraphs
    description.split("\n").reject(&:blank?)
  end
end
