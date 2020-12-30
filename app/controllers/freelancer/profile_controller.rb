# frozen_string_literal: true

class Freelancer::ProfileController < ApplicationController
  include LoggedInRedirects
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect

  def show
    @freelancer_profile = current_user.freelancer_profile
    real_estate_skills
  end

  def change_skills
    @freelancer_profile = current_user.freelancer_profile
    @freelancer_profile&.freelancer_real_estate_skills&.destroy_all
    real_estate_skill_params&.each do |skill|
      @freelancer_profile.freelancer_real_estate_skills.create(real_estate_skill_id: skill)
    end

    return redirect_to freelancer_profile_path(current_user) if @freelancer_profile.accepted?
    redirect_to freelancer_profile_step_path(:summary)
  end

  def change_software_licence
    @freelancer_profile = current_user.freelancer_profile
    @freelancer_profile&.freelancer_softwares&.destroy_all
    software_params&.each do |software|
      @freelancer_profile.freelancer_softwares.create(software_id: software)
    end

    return redirect_to freelancer_profile_path(current_user) if @freelancer_profile.accepted?
    redirect_to freelancer_profile_step_path(:summary)
  end

  private

  def real_estate_skill_params
    params[:freelancer_profile][:freelancer_real_estate_skills]&.reject(&:blank?)
  end

  def software_params
    params[:freelancer_softwares][:freelancer_softwares]
  end

  def real_estate_skills
    @real_estate_skills ||= RealEstateSkill.enabled.pluck(:description, :id)
  end
end
