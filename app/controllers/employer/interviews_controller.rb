# frozen_string_literal: true

class Employer::InterviewsController < ApplicationController
  include LoggedInRedirects
  before_action :authenticate_user!, :initial_check, :non_employer_redirect,
                :incomplete_employer_profile_redirect
  ITEMS_PER_PAGE = 5

  def index
    @pagy, @interviews = pagy(interview_requests_collection, items: ITEMS_PER_PAGE, overflow: :last_page)
  end

  private

  def interview_requests_collection
    @interview_requests_collection ||= current_user.employer_profile
                                                   .interview_requests
                                                   .not_rejected
                                                   .order(state: :asc, created_at: :desc)
  end
end
