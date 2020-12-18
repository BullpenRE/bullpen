# frozen_string_literal: true

class Freelancer::ApplicationsController < ApplicationController
  include LoggedInRedirects
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect, :incomplete_freelancer_profile_redirect
  ITEMS_PER_PAGE = 10

  def index
    @show_when_applied = true
    @pagy, @job_applications = pagy(current_user.job_applications.order(created_at: :desc), items: ITEMS_PER_PAGE, overflow: :last_page)
  end
end
