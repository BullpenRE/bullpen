# frozen_string_literal: true

class Freelancer::ProfileController < ApplicationController
  include LoggedInRedirects
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect

  def change_skills
    @freelancer_profile = current_user.freelancer_profile
    @freelancer_profile&.freelancer_real_estate_skills&.destroy_all
    real_estate_skill_params&.each do |skill|
      @freelancer_profile.freelancer_real_estate_skills.create(real_estate_skill_id: skill)
    end

    redirect_to freelancer_profile_step_path(:summary)
  end

  private

  def real_estate_skill_params
    params[:freelancer_profile][:freelancer_real_estate_skills]&.reject(&:blank?)
  end
end
