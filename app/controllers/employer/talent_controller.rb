# frozen_string_literal: true

class Employer::TalentController < ApplicationController
include LoggedInRedirects
before_action :authenticate_user!, :initial_check, :non_employer_redirect, :incomplete_employer_profile_redirect

  def index
    @pagy, @freelancer_profiles = pagy(FreelancerProfile.includes(:real_estate_skills,
                                                                  :sectors,
                                                                  :softwares,
                                                                  :freelancer_certifications,
                                                                  :freelancer_profile_educations,
                                                                  :freelancer_profile_experiences).where(draft: false),
                                       items: 5)
  end

  def interview_request
    @interview_request = current_user.employer_profile.interview_requests.create(interview_request_params)
    flash[:notice] = "<strong> Success!</strong> Your interview request has been sent to <a href='#' class='alert-link'>
         #{@interview_request.freelancer_profile.first_name} #{@interview_request.freelancer_profile.last_name}
         </a>. We will send notification when it is accepted or declined." if @interview_request.valid?
    redirect_to employer_talent_index_path
  end

  private

  def interview_request_params
    params.require(:interview_request).permit(:freelancer_profile_id, :state)
  end
end
