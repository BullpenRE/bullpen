# frozen_string_literal: true

class Employer::TalentController < ApplicationController
  before_action :authenticate_user!

  def index
    @freelancer_profiles = FreelancerProfile.includes(:real_estate_skills,
                                                      :sectors,
                                                      :softwares,
                                                      :freelancer_certifications,
                                                      :freelancer_profile_educations,
                                                      :freelancer_profile_experiences).where(draft: false)
  end

end
