# frozen_string_literal: true

module RedirectPath
  def current_step
    current_user.role == 'employer' ?  current_user.employer_profile.current_step : current_user.freelancer_profile.current_step
  end

  def url_for_redirect
    set_path+'/'+current_step
  end

  def set_path
    current_user.role == 'employer' ? employer_profile_steps_path : freelancer_profile_steps_path
  end
end
