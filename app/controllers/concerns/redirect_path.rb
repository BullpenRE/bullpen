# frozen_string_literal: true

module RedirectPath
  def user
    User.find_by(id: session[:user_id])
  end

  def current_step
    user.role == 'employer' ?  user.employer_profile.current_step : user.freelancer_profile.current_step
  end

  def url_for_redirect
    set_path+'/'+current_step
  end

  def set_path
    user.role == 'employer' ? employer_profile_steps_path : freelancer_profile_steps_path
  end
end
