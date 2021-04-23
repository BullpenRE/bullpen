# frozen_string_literal: true

class Employer::InterviewsController < ApplicationController
  before_action :authenticate_user!, :initial_check, :non_employer_redirect,
                :incomplete_employer_profile_redirect
  ITEMS_PER_PAGE = 5

  def index
    @pagy, @interviews = pagy(interview_requests_collection, items: ITEMS_PER_PAGE, overflow: :last_page)

    mixpanel_interview_tracker('Show all interviews')
    redirect_to employer_talent_index_path if @interviews.blank?
  end

  def withdraw_request
    @interview_request = current_user.employer_profile.interview_requests.find_by(id: params[:id])
    @interview_request.update(state: 'withdrawn')
    mixpanel_interview_tracker('Withdraw Interview')
    FreelancerMailer.interview_request_was_withdrawn(@interview_request).deliver_later
  end

  def remove_interview_request
    @interview_request = current_user.employer_profile.interview_requests.find_by(id: params[:id])
    @interview_request.update(hide_from_employer: true)
  end

  private

  def interview_requests_collection
    @interview_requests_collection ||= current_user.employer_profile
                                                   .interview_requests
                                                   .not_rejected
                                                   .employer_visible
                                                   .freelancer_enabled
                                                   .order(state: :asc, created_at: :desc)
  end

  def mixpanel_interview_tracker(action)
    MixpanelWorker.perform_async(current_user.id, action, { 'user': current_user.email })
  end
end
