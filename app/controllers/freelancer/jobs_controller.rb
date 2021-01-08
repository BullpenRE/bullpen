# frozen_string_literal: true

class Freelancer::JobsController < ApplicationController
  include LoggedInRedirects
  before_action :save_apply_for_job_in_session,
                only: [:index], if: -> { params[:apply_for_job].present? && !user_signed_in? }
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect, :incomplete_freelancer_profile_redirect
  ITEMS_PER_PAGE = 10

  def index
    if params[:apply_for_job].present? && jobs_collection.find_by(slug: params[:apply_for_job]).present?
      index = jobs_collection.map(&:slug).index(params[:apply_for_job])
      page = ((index + 1) / ITEMS_PER_PAGE.to_f).ceil
      @job_id = jobs_collection.find_by(slug: params[:apply_for_job]).id
      @pagy, @jobs = pagy(jobs_collection, page: page, items: ITEMS_PER_PAGE, overflow: :last_page)
    else
      @pagy, @jobs = pagy(jobs_collection, items: ITEMS_PER_PAGE, overflow: :last_page)
    end

    delete_session_variable
  end

  private

  def jobs_collection
    Job.where(state: 'posted').order(created_at: :desc).not_applied(current_user)
  end

  def save_apply_for_job_in_session
    session[:apply_for_job] = params[:apply_for_job]

    redirect_to freelancer_jobs_path
  end

  def delete_session_variable
    session.delete(:apply_for_job)
  end
end
