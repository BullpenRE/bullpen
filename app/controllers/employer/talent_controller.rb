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
  end
end
