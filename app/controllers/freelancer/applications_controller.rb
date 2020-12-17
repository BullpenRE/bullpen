# frozen_string_literal: true

class Freelancer::ApplicationsController < ApplicationController
  include LoggedInRedirects
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect, :incomplete_freelancer_profile_redirect
  ITEMS_PER_PAGE = 10

  def index
    byebug
    @pagy, @job_applications = pagy(current_user.job_applications, items: ITEMS_PER_PAGE, overflow: :last_page)
    EmployerMailer.new_job_application(current_user, current_user.job_applications).deliver_now
  end
end
