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

    @current_user_interview_request_freelancer_ids = current_user.employer_profile
                                                                 .interview_requests
                                                                 .pluck(:freelancer_profile_id)
  end

  def interview_request
    @interview_request = current_user.employer_profile.interview_requests.create(interview_request_params)

    if @interview_request.valid?
      flash[:notice] = '<i class="far fa-check-circle"></i> <strong> Success!</strong> '\
      'Your interview request has been sent to '\
      "<strong>#{@interview_request.freelancer_profile.full_name}</strong>. "\
      'We will send you a notification when it is accepted or declined.'
    end
    FreelancerMailer.interview_request(@interview_request).deliver_now

    redirect_to employer_talent_index_path
  end

  private

  def interview_request_params
    params.require(:interview_request).permit(:freelancer_profile_id, :state)
  end
end
