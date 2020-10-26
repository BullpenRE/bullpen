# frozen_string_literal: true

class FreelancerProfileEducation < ApplicationRecord
  belongs_to :freelancer_profile
  has_one :user, through: :freelancer_profile

  validates :institution, presence: true
  validates :degree, presence: true
  validates :course_of_study, presence: true

  AVAILABLE_YEARS = (40.years.ago.year..Time.now.year).reverse_each
  enum degree: { 'BS': 0, 'BA': 1, 'Masters': 2, 'PHD': 3 }

end
