# frozen_string_literal: true

class Freelancer::ProfileController < ApplicationController
  include LoggedInRedirects
  include WorkEducationExperience
  include WorkCertification
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect, :freelancer_profile

  def index
    real_estate_skills
    certifications
    sectors
  end

  def change_skills
    freelancer_profile&.freelancer_real_estate_skills&.destroy_all
    real_estate_skill_params&.each do |skill|
      freelancer_profile.freelancer_real_estate_skills.create(real_estate_skill_id: skill)
    end

    redirect_after_change_profile
  end

  def change_software_licence
    freelancer_profile&.freelancer_softwares&.destroy_all
    software_params&.each do |software|
      freelancer_profile.freelancer_softwares.create(software_id: software)
    end

    redirect_after_change_profile
  end

  def change_certifications
    freelancer_certification_options

    redirect_after_change_profile
  end

  def change_educations
    freelancer_education_options

    redirect_after_change_profile
  end

  def change_freelancer_basic_info
    first_name = params[:freelancer_profile][:first_name]
    last_name = params[:freelancer_profile][:last_name]
    location = params[:freelancer_profile][:location]

    @freelancer_profile.user.update(first_name: first_name, last_name: last_name, location: location)
    @freelancer_profile.update(change_basic_info_params)

    change_freelancer_sectors

    params[:reference_path].present? ? redirect_to(params[:reference_path]) : redirect_after_change_profile
  end

  def change_work_experience
    work_experience_save

    redirect_after_change_profile
  end

  def change_freelancer_sectors
    freelancer_profile&.freelancer_sectors&.destroy_all
    sectors_params&.each do |sector|
      freelancer_profile.freelancer_sectors.create(sector_id: sector)
    end
  end

  private

  def freelancer_profile
    @freelancer_profile ||= current_user.freelancer_profile
  end

  def real_estate_skill_params
    params[:freelancer_profile][:freelancer_real_estate_skills]&.reject(&:blank?)
  end

  def redirect_after_change_profile
    return redirect_to freelancer_profile_index_path if freelancer_profile.accepted?

    redirect_to freelancer_profile_step_path(:summary)
  end

  def software_params
    params[:freelancer_softwares][:freelancer_softwares]
  end

  def change_basic_info_params
    params.require(:freelancer_profile)
          .permit(:professional_title, :professional_years_experience, :professional_summary, :desired_hourly_rate)
  end

  def real_estate_skills
    @real_estate_skills ||= RealEstateSkill.enabled.pluck(:description, :id)
  end

  def certifications
    @certifications ||= Certification.enabled.pluck(:description, :id)
  end

  def sectors
    @sectors ||= Sector.enabled.pluck(:description, :id)
  end

  def sectors_params
    params[:freelancer_profile][:freelancer_sectors]&.reject(&:blank?)
  end
end
