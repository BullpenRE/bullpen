# frozen_string_literal: true

class Freelancer::JobsController < ApplicationController
  include LoggedInRedirects
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect, :incomplete_freelancer_profile_redirect
  ITEMS_PER_PAGE = 10

  def index
    @pagy, @jobs = pagy(Job.where(state: 'posted').not_applied(current_user), items: ITEMS_PER_PAGE, overflow: :last_page)
    @job_applications = current_user.job_applications
  end
end
