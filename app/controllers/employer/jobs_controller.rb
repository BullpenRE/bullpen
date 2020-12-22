# frozen_string_literal: true

class Employer::JobsController < ApplicationController
  include LoggedInRedirects
  before_action :save_open_in_session, only: [:index], if: -> { params[:open].present? && !user_signed_in? }
  before_action :authenticate_user!, :initial_check, :non_employer_redirect,
                :incomplete_employer_profile_redirect
  ITEMS_PER_PAGE = 10

  def index
    if params[:open].present?
      index = jobs_collection.map(&:id).index(params[:open].to_i)
      page = ((index + 1) / ITEMS_PER_PAGE.to_f).ceil
      @pagy, @jobs = pagy(jobs_collection, page: page, items: ITEMS_PER_PAGE, overflow: :last_page)
    else
      @pagy, @jobs = pagy(jobs_collection, items: ITEMS_PER_PAGE, overflow: :last_page)
    end

    delete_session_variable
  end

  def destroy
    job.destroy
  end

  def post_job
    job.update(state: 'posted')

    redirect_to employer_jobs_path
  end

  private

  def job
    @job ||= current_user.jobs.find_by(id: params[:id])
  end

  def jobs_collection
    @jobs_collection ||= current_user.jobs.order(created_at: :desc)
  end

  def save_open_in_session
    session[:open] = params[:open]

    redirect_to employer_jobs_path
  end

  def delete_session_variable
    session.delete(:open)
  end
end
