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

  def store_location
    session[:previous_url] = request.fullpath if !request.xhr? && save_location_path?(request.fullpath)
  end

  def save_location_path?(fullpath)
    # The following paths will have redirects after logout/login
    %w[/employer/jobs /employer/interviews /employer/contracts /employer/account
       /freelancer/applications /freelancer/interviews /freelancer/contracts /freelancer/profile].each do |pattern|
      return true if fullpath.index(pattern)&.zero?
    end
    false
  end

  def confirm_employer_account_flash_notice
    return if current_user.confirmed_at.present?

    flash[:warning] = 'Please check your email and confirm your account'
  end

  private

  def determine_correct_path(resource)
    if resource.freelancer?
      path_for_freelancer(resource)
    elsif resource.employer?
      path_for_employer(resource)
    end
  end

  def path_for_freelancer(user)
    return freelancer_interviews_redirect if session[:view_interview_request].present?
    return session[:previous_url] if session[:previous_url] && current_user.freelancer_profile&.accepted?

    current_user.freelancer_profile&.accepted? ? freelancer_jobs_path : current_freelancer_profile_step(user)
  end

  def freelancer_interviews_redirect
    freelancer_interviews_path(view_interview_request: session[:view_interview_request])
  end

  def path_for_employer(user)
    return employer_jobs_path(view_job: session[:view_job]) if session[:view_job].present?
    return session[:previous_url] if session[:previous_url] && current_user.employer_profile&.completed?

    current_user.employer_profile&.completed? ? employer_talent_index_path : current_employer_profile_step(user)
  end

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
    current_user.employer_profile.completed? ? employer_talent_index_path : current_signup_step_url
  end

  def freelancer_current_path
    current_user.freelancer_profile.curation == 'accepted' ? freelancer_jobs_path : current_signup_step_url
  end

  def current_step
    current_user.role == 'employer' ? current_user.employer_profile.current_step : current_freelancer_step
  end

  def current_freelancer_step
    return 'summary' if current_user.freelancer_profile&.declined?

    current_user.freelancer_profile&.current_step
  end
end
