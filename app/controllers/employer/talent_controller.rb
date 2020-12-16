# frozen_string_literal: true

class Employer::TalentController < ApplicationController
  include LoggedInRedirects
  before_action :authenticate_user!, :initial_check, :non_employer_redirect, :incomplete_employer_profile_redirect

  def index
    filters_list unless invalid_filtering_parameters?
    @pagy, @freelancer_profiles = pagy(freelancer_profiles_collection, items: 5)
  end

  private

  def all_freelancer_profiles
    FreelancerProfile.includes(:real_estate_skills,
                               :sectors,
                               :softwares,
                               :freelancer_certifications,
                               :freelancer_profile_educations,
                               :freelancer_profile_experiences).where(draft: false)
  end

  def freelancer_profiles_collection
    return all_freelancer_profiles if invalid_filtering_parameters?

    filter = EmployerFreelancersHelper::Filter.new(
      sector_ids: sector_ids,
      real_estate_skill_ids: real_estate_skill_ids,
      software_ids: software_ids
    )

    all_freelancer_profiles.where(id: filter.freelancer_profile_ids)
  end

  def filtering_params
    params.require(:search).permit(sector_ids: [], real_estate_skill_ids: [], software_ids: [])
  end

  def sector_ids
    filtering_params[:sector_ids].reject(&:empty?).map(&:to_i)
  end

  def real_estate_skill_ids
    filtering_params[:real_estate_skill_ids].reject(&:empty?).map(&:to_i)
  end

  def software_ids
    filtering_params[:software_ids].reject(&:empty?).map(&:to_i)
  end

  def invalid_filtering_parameters?
    params[:search].blank? || (sector_ids.blank? && real_estate_skill_ids.blank? && software_ids.blank?)
  end

  def filters_list
    @filters_list ||= Sector.where(id: sector_ids).map(&:description) +
                      RealEstateSkill.where(id: real_estate_skill_ids).map(&:description) +
                      Software.where(id: software_ids).map(&:description)
  end
end

