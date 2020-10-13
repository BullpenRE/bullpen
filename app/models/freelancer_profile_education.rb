class FreelancerProfileEducation < ApplicationRecord
  belongs_to :freelancer_profile

  validates :institution, presence: true
  validates :degree, presence: true
  validates :course_of_study, presence: true

  AVAILABLE_YEARS = (1981..Time.now.year).reverse_each
  enum degree: ['BS', 'BA', 'Masters', 'PHD']

end
