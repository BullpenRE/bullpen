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

  def interview_request
    @interview_request = current_user.employer_profile.interview_requests.create(interview_request_params)
    redirect_to employer_talent_index_path
  end

private
def interview_request_params
  params.require(:interview_request).permit(:freelancer_profile_id, :state)
end


end
