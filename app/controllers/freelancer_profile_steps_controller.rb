# frozen_string_literal: true

class FreelancerProfileStepsController < ApplicationController
  include Wicked::Wizard
  include WorkEducationExperience
  steps :skills_page, :avatar_location, :professional_history, :work_education_experience, :summary, :final_step

  def show
    @user = current_user
    if @user.freelancer_profile.blank?
      FreelancerProfile.create(user_id: @user.id)
      @user.reload
    end
    @freelancer_profile = @user.freelancer_profile
    render_wizard
  end

  def update
    @user = current_user
    @freelancer_profile = @user.freelancer_profile
    skills_page_save ||
      professional_history_save ||
      work_education_experience_save ||
      location_save ||
      summary_save
  end

  def summary_save
    return false unless wizard_value(step) == :summary

    @freelancer_profile.is_draft = params[:freelancer_profile][:is_draft]
    @freelancer_profile.save
    render_wizard @user

    true
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

    destroy_old_re_skills_and_asset_classes
    real_estate_skill_params&.each do |skill|
      FreelancerRealEstateSkill.create(freelancer_profile_id: @freelancer_profile.id, real_estate_skill_id: skill)
    end
    asset_classes_params&.each do |asset|
      FreelancerAssetClass.create(freelancer_profile_id: @freelancer_profile.id, asset_class_id: asset)
    end
    render_wizard @user

    true
  end

  private

  def destroy_old_re_skills_and_asset_classes
    @freelancer_profile&.freelancer_real_estate_skills&.destroy_all
    @freelancer_profile&.freelancer_asset_classes&.destroy_all
  end

  def real_estate_skill_params
    params[:freelancer_profile][:freelancer_real_estate_skills]&.reject(&:blank?)
  end

  def asset_classes_params
    params[:freelancer_profile][:freelancer_asset_classes]&.reject(&:blank?)
  end

  def history_params
    params.require(:freelancer_profile)
      .permit(:professional_title, :professional_years_experience, :professional_summary)
  end
end
