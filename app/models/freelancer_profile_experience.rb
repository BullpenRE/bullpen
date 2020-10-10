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
    start_date = "#{self.start_year}-#{self.start_month}"
    self.start_date = Date.strptime(start_date, '%Y-%m')
  end

  def update_end_date
    return unless self.end_year.present? && self.end_month.present?

    end_date = "#{self.end_year}-#{self.end_month}"
    self.end_date = Date.strptime(end_date, '%Y-%m')
  end
end
