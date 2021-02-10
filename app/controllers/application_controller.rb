# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend

  after_action :store_location

  def after_sign_in_path_for(resource)
    return admin_dashboard_path if resource.class.name == 'AdminUser'

    determine_correct_path(resource)
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
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

  private

  def current_freelancer_profile_step(user)
    return freelancer_profile_steps_path(id: :summary) if profile_declined?(user)
    return freelancer_profile_steps_path(id: :final_step) if profile_pending?(user)
    return freelancer_profile_steps_path if user.freelancer_profile.current_step.blank?

    freelancer_profile_steps_path(id: user.freelancer_profile.current_step)
  end

  def current_employer_profile_step(user)
    return employer_profile_steps_path if user.employer_profile.current_step.blank?

    employer_profile_steps_path(id: user.employer_profile.current_step)
  end

  def profile_pending?(user)
    user.freelancer_profile.draft == false && user.freelancer_profile.pending?
  end

  def profile_declined?(user)
    user.freelancer_profile.declined?
  end

  def determine_correct_path(resource)
    if resource.freelancer?
      path_for_freelancer(resource)
    elsif resource.employer?
      path_for_employer(resource)
    end
  end

  def path_for_freelancer(user)
    return session[:previous_url] if session[:previous_url] && current_user.freelancer_profile&.accepted?
    return freelancer_interviews_redirect if session[:view_interview_request].present?

    current_user.freelancer_profile&.accepted? ? freelancer_jobs_path : current_freelancer_profile_step(user)
  end

  def freelancer_interviews_redirect
    freelancer_interviews_path(view_interview_request: session[:view_interview_request])
  end

  def path_for_employer(user)
    return session[:previous_url] if session[:previous_url] && current_user.employer_profile&.completed?
    return employer_jobs_path(view_job: session[:view_job]) if session[:view_job].present?

    current_user.employer_profile&.completed? ? employer_talent_index_path : current_employer_profile_step(user)
  end
end
