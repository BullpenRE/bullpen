# frozen_string_literal: true

class Freelancer::ProfileController < ApplicationController
  include LoggedInRedirects
  include WorkEducationExperience
  include WorkCertification
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect, :freelancer_profile

  def index
    real_estate_skills
    certifications
  end

  def change_skills
    freelancer_profile&.freelancer_real_estate_skills&.destroy_all
    real_estate_skill_params&.each do |skill|
      freelancer_profile.freelancer_real_estate_skills.create(real_estate_skill_id: skill)
    end

    redirect_after_change_profile
    freelancer_skills_edited_flash_notice!
  end

  def change_software_licence
    freelancer_profile&.freelancer_softwares&.destroy_all
    software_params&.each do |software|
      freelancer_profile.freelancer_softwares.create(software_id: software)
    end

    redirect_after_change_profile
    freelancer_software_licence_edited_flash_notice!
  end

  def change_certifications
    freelancer_certification_options

    redirect_after_change_profile
    freelancer_certifications_edited_flash_notice!
  end

  def change_educations
    freelancer_education_options

    redirect_after_change_profile
    freelancer_educations_edited_flash_notice!
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

  def real_estate_skills
    @real_estate_skills ||= RealEstateSkill.enabled.pluck(:description, :id)
  end

  def certifications
    @certifications ||= Certification.enabled.pluck(:description, :id)
  end

  def freelancer_skills_edited_flash_notice!
    flash[:notice] = '<i class="far fa-check-circle"></i> <strong> Success!</strong> '\
                     "Freelancer's skills data were edited."
  end

  def freelancer_software_licence_edited_flash_notice!
    flash[:notice] = '<i class="far fa-check-circle"></i> <strong> Success!</strong> '\
                     "Freelancer's software licence data were edited."
  end

  def freelancer_certifications_edited_flash_notice!
    flash[:notice] = '<i class="far fa-check-circle"></i> <strong> Success!</strong> '\
                     "Freelancer's certifications data were edited."
  end

  def freelancer_educations_edited_flash_notice!
    flash[:notice] = '<i class="far fa-check-circle"></i> <strong> Success!</strong> '\
                     "Freelancer's educations data were edited."
  end
end
