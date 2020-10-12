class FreelancerProfileEducation < ApplicationRecord
  belongs_to :freelancer_profile

  AVAILABLE_YEARS = (1981..Time.now.year).reverse_each
  enum degree: ['BS', 'BA', 'Masters', 'PHD']

end
