# frozen_string_literal: true

module LoggedInRedirects
  def current_signup_step_url
    "#{current_path}/#{current_step}"
  end

  def freelancer_check
    redirect_to employer_current_path unless current_user.freelancer?
  end

  def employer_check
    redirect_to freelancer_current_path if current_user.freelancer?
  end

  def check_complete_employer_profile
    redirect_to current_signup_step_url unless completed_employer_profile?
  end

  def check_accept_freelancer_profile
    redirect_to current_signup_step_url unless accepted_freelancer_profile?
  end

  private

  def completed_employer_profile?
    current_user.employer? && current_user.employer_profile.completed?
  end

  def accepted_freelancer_profile?
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
