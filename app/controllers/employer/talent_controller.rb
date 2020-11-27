# frozen_string_literal: true

class Employer::TalentController < ApplicationController
include LoggedInRedirects
before_action :authenticate_user!, :initial_check, :non_employer_redirect, :incomplete_employer_profile_redirect

  def index
    @freelancer_profiles = FreelancerProfile.includes(:real_estate_skills,
                                                      :sectors,
                                                      :softwares,
                                                      :freelancer_certifications,
                                                      :freelancer_profile_educations,
                                                      :freelancer_profile_experiences).where(draft: false)
    @freelancer_profile = FreelancerProfile.new
    @real_estate_skills = RealEstateSkill.enabled.map{ |skill| [skill.description, skill.id] }
    @sectors = Sector.enabled.map{ |sector| [sector.description, sector.id] }
    @softwares = Software.enabled.map{ |software| [software.description, software.id] }
  end
end
