# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def after_sign_in_path_for(user)
    return admin_dashboard_path if user.class.name == 'AdminUser'

    if user.freelancer?
      current_freelancer_profile_step(user)
    elsif user.employer?
      current_employer_profile_step(user)
    end
  end

  private

  def current_freelancer_profile_step(user)
    return freelancer_profile_steps_path if user.freelancer_profile.current_step.blank?
    return freelancer_profile_steps_path(id: :final_step) if profile_pending?(user)

    freelancer_profile_steps_path(id: user.freelancer_profile.current_step)
  end

  def current_employer_profile_step(user)
    return employer_profile_steps_path if user.employer_profile.current_step.blank?

    employer_profile_steps_path(id: user.employer_profile.current_step)
  end

  def profile_pending?(user)
    user.freelancer_profile.is_draft == false && user.freelancer_profile.pending_profile?
  end
end
