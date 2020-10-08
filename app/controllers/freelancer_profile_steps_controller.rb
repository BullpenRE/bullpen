# frozen_string_literal: true

class FreelancerProfileStepsController < ApplicationController
  include Wicked::Wizard
  steps :skills_page, :professional_history

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

    render_wizard @user
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
end
