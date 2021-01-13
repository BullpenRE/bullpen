# frozen_string_literal: true

class Freelancer::JobsController < ApplicationController
  include LoggedInRedirects
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect, :incomplete_freelancer_profile_redirect
  ITEMS_PER_PAGE = 10

  def index
    @pagy, @jobs = pagy(jobs_collection, page: page, items: ITEMS_PER_PAGE, overflow: :last_page)
  end

  private

  def page
    return params[:page] || 1 unless session[:apply_for_job]

    index = jobs_collection.pluck(:slug).index(session[:apply_for_job])
    @apply_for_job_id = jobs_collection[index].id
    session.delete(:apply_for_job)

    ((index + 1) / ITEMS_PER_PAGE.to_f).ceil
  end

  def jobs_collection
    Job.where(state: 'posted').order(created_at: :desc).not_applied_or_withdrawn(current_user)
  end
end
