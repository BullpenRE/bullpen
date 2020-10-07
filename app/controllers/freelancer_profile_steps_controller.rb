# frozen_string_literal: true

class FreelancerProfileStepsController < ApplicationController
  include Wicked::Wizard
  steps :skills_page, :professional_history

  def show
    @user = current_user
    FreelancerProfile.create(user_id: @user.id) if @user.freelancer_profile.blank?
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
    @freelancer_profile&.freelancer_real_estate_skills&.delete_all
    @freelancer_profile&.freelancer_asset_classes&.delete_all
    params[:freelancer_profile][:freelancer_real_estate_skills]&.reject(&:blank?)&.each do |skill|
      FreelancerRealEstateSkill.create(freelancer_profile_id: @freelancer_profile.id, real_estate_skill_id: skill)
    end
    params[:freelancer_profile][:freelancer_asset_classes]&.reject(&:blank?)&.each do |asset|
      FreelancerAssetClass.create(freelancer_profile_id: @freelancer_profile.id, asset_class_id: asset)
    end
  end

  def history_params
    params.require(:freelancer_profile)
          .permit(:professional_title, :professional_years_experience, :professional_summary)
  end
end
