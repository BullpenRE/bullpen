# frozen_string_literal: true

module LoggedInRedirects
  def current_signup_step_url
    "#{current_path}/#{current_step}"
  end

  def initial_check
    redirect_to root_path if current_user.role.blank?
  end

  def non_freelancer_redirect
    redirect_to employer_current_path unless current_user.freelancer?
  end

  def non_employer_redirect
    redirect_to freelancer_current_path if current_user.freelancer?
  end

  def incomplete_employer_profile_redirect
    redirect_to current_signup_step_url unless employer_profile_steps_path?
  end

  def incomplete_freelancer_profile_redirect
    redirect_to current_signup_step_url unless freelancer_profile_steps_path?
  end

  private

  def employer_profile_steps_path?
    current_user.employer? && current_user.employer_profile.completed?
  end

  def freelancer_profile_steps_path?
    current_user.freelancer? && current_user.freelancer_profile.curation == 'accepted'
  end

  def current_path
    current_user.employer? ? employer_profile_steps_path : freelancer_profile_steps_path
  end

  def employer_current_path
    current_user.employer_profile.completed? ? employer_jobs_path : current_signup_step_url
  end

  def freelancer_current_path
    current_user.freelancer_profile.curation == 'accepted' ? freelancer_jobs_path : current_signup_step_url
  end

  def current_step
    current_user.role == 'employer' ?  current_user.employer_profile.current_step : current_user.freelancer_profile.current_step
  end
end
