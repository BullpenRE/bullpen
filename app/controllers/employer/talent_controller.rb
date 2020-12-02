# frozen_string_literal: true

class Employer::TalentController < ApplicationController
  include LoggedInRedirects
  before_action :authenticate_user!, :initial_check, :non_employer_redirect, :incomplete_employer_profile_redirect

  helper_method :filters_selected, :real_estate_skills, :sectors, :softwares, :freelancer_profiles

  def index
  end

  def filter_freelancer_profiles
    filters_selected
  end

  private

  def filters_selected
    @filters_selected ||= []
    @filters_selected = [filter_params[:real_estate_skills_descriptions],
                         filter_params[:sectors_descriptions],
                         filter_params[:softwares_descriptions]].compact
  end

  def real_estate_skills
    @real_estate_skills = RealEstateSkill.enabled.map(&:description)
  end

  def sectors
    @sectors = Sector.enabled.map(&:description)
  end

  def softwares
    @softwares = Software.enabled.map(&:description)
  end

  def freelancer_profiles
    @freelancer_profiles ||= FreelancerProfile
                               .includes(:real_estate_skills,
                                         :sectors,
                                         :softwares,
                                         :freelancer_certifications,
                                         :freelancer_profile_educations,
                                         :freelancer_profile_experiences)
                               .where(draft: false)
    if filter_params.include?(:real_estate_skills_descriptions)

      @freelancer_profiles = @freelancer_profiles.joins(:real_estate_skills).where(real_estate_skills: {
          description: filter_params[:real_estate_skills_descriptions]
      })
    end
    if filter_params.include?(:sectors_descriptions)

      @freelancer_profiles = @freelancer_profiles.joins(:sectors).where(sectors: {
          description: filter_params[:sectors_descriptions]
      })
    end
    if filter_params.include?(:softwares_descriptions)

      @freelancer_profiles = @freelancer_profiles.joins(:softwares).where(softwares: {
          description: filter_params[:softwares_descriptions]
      })
    end
    @freelancer_profiles
  end

  def filter_params
    params.permit(:real_estate_skills_descriptions => [],
                  :sectors_descriptions => [],
                  :softwares_descriptions => [])
  end
end
