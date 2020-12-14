# frozen_string_literal: true

# In general using helpers too much goes to a bad place. Be careful...

module ApplicationHelper
  include Pagy::Frontend

  def select_months_array
    FreelancerProfileExperience::AVAILABLE_MONTHNAMES.each_with_index.collect { |m, i| [m, i+1] }
  end

  def pagy_nav_sizes
    {
      0 => [0,1,1,0],
      540 => [3,5,5,3],
      720 => [5,7,7,5]
    }
  end
end
