# frozen_string_literal: true

module LoggedInRedirects
  def current_step
    current_user.role == 'employer' ?  current_user.employer_profile.current_step : current_user.freelancer_profile.current_step
  end

  def current_signup_step_url
    "#{current_path}/#{current_step}"
  end

  def current_path
    current_user.role == 'employer' ? employer_profile_steps_path : freelancer_profile_steps_path
  end
end
