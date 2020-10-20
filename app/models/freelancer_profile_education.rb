# frozen_string_literal: true

class FreelancerProfileEducation < ApplicationRecord
  belongs_to :freelancer_profile
  has_one :user, through: :freelancer_profile

  validates :institution, presence: true
  validates :degree, presence: true
  validates :course_of_study, presence: true

  AVAILABLE_YEARS = (40.years.ago.year..Time.now.year).reverse_each
  enum degree: %w[BS BA Masters PHD]

end
