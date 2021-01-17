# frozen_string_literal: true

class Employer::JobsController < ApplicationController
  include LoggedInRedirects
  before_action :save_view_job_in_session, only: [:index], if: -> { params[:view_job].present? && !user_signed_in? }
  before_action :authenticate_user!, :initial_check, :non_employer_redirect,
                :incomplete_employer_profile_redirect
  ITEMS_PER_PAGE = 10

  def index
    if params[:view_job].present?
      index = jobs_collection.map(&:id).index(params[:view_job].to_i)
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

  def like_job_application
    @job_application = JobApplication.find(params[:id])
    @job_application.liked ? @job_application.update(liked: false) : @job_application.update(liked: true)
  end

  def send_message
    @job = current_user.jobs.find(params[:message][:job_id].to_i)
    @message = Message.create(message_params)
    FreelancerMailer.send_message(@message, @job).deliver_now

    redirect_to employer_jobs_path
  end

  private

  def message_params
    {
      to_user_id: params[:message][:to_user].to_i,
      from_user: current_user,
      description: params[:message][:description]
    }
  end

  def job
    @job ||= current_user.jobs.find_by(id: params[:id])
  end

  def jobs_collection
    @jobs_collection ||= current_user.jobs.order(created_at: :desc)
  end

  def save_view_job_in_session
    session[:view_job] = params[:view_job]

    redirect_to employer_jobs_path
  end

  def delete_session_variable
    session.delete(:view_job)
  end
end
