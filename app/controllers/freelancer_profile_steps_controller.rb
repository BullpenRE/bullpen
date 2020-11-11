# frozen_string_literal: true

class FreelancerProfileStepsController < ApplicationController
  include Wicked::Wizard
  include WorkEducationExperience
  steps :skills_page, :avatar_location, :professional_history, :work_education_experience, :summary, :final_step
  before_action :authenticate_user!

  def show
    @user = current_user
    if @user.freelancer_profile.blank?
      FreelancerProfile.create(user_id: @user.id)
      @user.reload
    end
    @freelancer_profile = @user.freelancer_profile
    @real_estate_skills = RealEstateSkill.enabled.map{ |skill| [skill.description, skill.id] }
    @sectors = Sector.enabled.map{ |sector| [sector.description, sector.id] }
    @softwares = Software.enabled.map{ |software| [software.description, software.id] }
    render_wizard
  end

  def update
    @user = current_user
    @freelancer_profile = @user.freelancer_profile
    save_current_step
    skills_page_save ||
      professional_history_save ||
      work_education_experience_save ||
      location_save ||
      summary_save
  end

  def summary_save
    return false unless wizard_value(step) == :summary

    @freelancer_profile.draft = params[:freelancer_profile][:draft]
    @freelancer_profile.save
    render_wizard @user

    true
  end

  def finish_wizard_path
    return wizard_path(:summary) if pending_profile?

    reset_session
    root_path
  end

  def location_save
    return false unless wizard_value(step) == :avatar_location

    @user.location = params[:user][:location]
    @user.save
    render_wizard @user

    true
  end

  def work_education_experience_save
    return false unless wizard_value(step) == :work_education_experience

    freelancer_profile_education_save
    work_experience_save

    render wizard_path(:work_education_experience)

    true
  end

  def professional_history_save
    return false unless wizard_value(step) == :professional_history

    @freelancer_profile.update_attributes(history_params)
    render_wizard @user

    true
  end

  def skills_page_save
    return false unless wizard_value(step) == :skills_page

    destroy_old_re_skills_and_sectors
    destroy_old_softwares
    real_estate_skill_params&.each do |skill|
      FreelancerRealEstateSkill.create(freelancer_profile_id: @freelancer_profile.id, real_estate_skill_id: skill)
    end
    sectors_params&.each do |sector|
      FreelancerSector.create(freelancer_profile_id: @freelancer_profile.id, sector_id: sector)
    end
    softwares_params&.each do |software|
      FreelancerSoftware.create(freelancer_profile_id: @freelancer_profile.id, software_id: software)
    end
    render_wizard @user

    true
  end

  private

  def pending_profile?
    @freelancer_profile.draft == false && @freelancer_profile.pending?
  end

  def save_current_step
    @freelancer_profile.current_step = wizard_value(next_step)
    @freelancer_profile.save
  end

  def destroy_old_re_skills_and_sectors
    @freelancer_profile&.freelancer_real_estate_skills&.destroy_all
    @freelancer_profile&.freelancer_sectors&.destroy_all
  end

  def destroy_old_softwares
    @freelancer_profile&.freelancer_softwares&.destroy_all
  end

  def real_estate_skill_params
    params[:freelancer_profile][:freelancer_real_estate_skills]&.reject(&:blank?)
  end

  def sectors_params
    params[:freelancer_profile][:freelancer_sectors]&.reject(&:blank?)
  end

  def softwares_params
    params[:freelancer_profile][:freelancer_softwares]&.reject(&:blank?)
  end

  def history_params
    params.require(:freelancer_profile)
      .permit(:professional_title, :professional_years_experience, :professional_summary)
  end
end
