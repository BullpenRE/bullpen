# frozen_string_literal: true

class FreelancerProfileStepsController < ApplicationController
  include Wicked::Wizard
  steps :skills_page, :professional_history, :work_education_experience

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
    skills_page_save if wizard_value(step) == :skills_page
    professional_history_save if wizard_value(step) == :professional_history
    if wizard_value(step) == :work_education_experience
      work_experience_save
      render wizard_path(:work_education_experience)
    else
      render_wizard @user
    end
  end

  def work_experience_save
    FreelancerProfileExperience.create(checked_profile_experience_params)
  end

  def professional_history_save
    @freelancer_profile.update_attributes(history_params)
  end

  def skills_page_save
    @freelancer_profile&.freelancer_real_estate_skills&.destroy_all
    @freelancer_profile&.freelancer_asset_classes&.destroy_all
    real_estate_skill_params&.each do |skill|
      FreelancerRealEstateSkill.create(freelancer_profile_id: @freelancer_profile.id, real_estate_skill_id: skill)
    end
    asset_classes_params&.each do |asset|
      FreelancerAssetClass.create(freelancer_profile_id: @freelancer_profile.id, asset_class_id: asset)
    end
  end

  private

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

  def profile_experience_params
    params.require(:freelancer_profile_experience)
      .permit(:job_title, :company, :location, :description,
              :start_month, :start_year, :end_month, :end_year, :current_job)
  end

  def checked_profile_experience_params
    experience_params = if params[:freelancer_profile_experience][:current_job] == true
                          profile_experience_params.reject { |param| param == 'end_month' || param == 'end_year' }
                        else
                          profile_experience_params
                        end

    experience_params.merge(freelancer_profile_id: @freelancer_profile.id)
  end
end
