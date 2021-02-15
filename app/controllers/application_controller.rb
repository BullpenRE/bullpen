# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include LoggedInRedirects
  include Pagy::Backend

  before_action :store_location

  def after_sign_in_path_for(resource)
    return admin_dashboard_path if resource.class.name == 'AdminUser'

    determine_correct_path(resource)
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
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
end
