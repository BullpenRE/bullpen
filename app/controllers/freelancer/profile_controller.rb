# frozen_string_literal: true

class Freelancer::ProfileController < ApplicationController
  include LoggedInRedirects
  include WorkEducationExperience
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect, :incomplete_freelancer_profile_redirect

  def change_certifications
    @freelancer_profile = current_user.freelancer_profile
    @freelancer_profile&.freelancer_certifications&.destroy_all
    certifications_params&.each do |certifications|
      @freelancer_profile.freelancer_certifications.create(certifications_id: certifications)
    end

    redirect_to freelancer_profile_step_path(:summary)
  end

  private

  def certifications_params
    byebug
    params[:freelancer_profile][:freelancer_certifications]&.reject(&:blank?)
  end

  def freelancer_certification
    @freelancer_profile&.freelancer_certifications&.find_by(id: params[:freelancer_certification][:id])
  end
end
