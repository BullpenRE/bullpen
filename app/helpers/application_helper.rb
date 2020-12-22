# frozen_string_literal: true

# In general using helpers too much goes to a bad place. Be careful...

module ApplicationHelper
  include Pagy::Frontend

  def select_months_array
    FreelancerProfileExperience::AVAILABLE_MONTHNAMES.each_with_index.collect { |m, i| [m, i+1] }
  end

  def mobile_device
    agent = request.user_agent

    return 'tablet' if agent =~ /(tablet|ipad)|(android(?!.*mobile))/i
    return 'mobile' if agent =~ /Mobile/

    'desktop'
  end
end
