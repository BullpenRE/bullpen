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
    job_title = params[:message][:job_title]
    @message = Message.create(message_params)
    FreelancerMailer.send_message(@message, job_title).deliver_later

    redirect_to redirect_path_after_send_message(job_title)
  end

  def decline_job_application
    @job_application = JobApplication.where(job: current_user.jobs).find_by(id: params[:id])
    return unless @job_application

    @job_application.update(state: 'declined')
    FreelancerMailer.job_application_declined(@job_application).deliver_later
  end

  def make_an_offer
    if contract_id.present?
      update_contract
      update_make_an_offer_flash_notice
      FreelancerMailer.offer_update(@contract).deliver_later

      redirect_to employer_contracts_path
    else
      create_contract
      create_make_an_offer_flash_notice
      FreelancerMailer.offer_made(@contract).deliver_later

      redirect_to employer_jobs_path
    end
  end

  private

  def contract_id
    params[:make_an_offer][:contract_id]
  end

  def create_contract
    @job = current_user.jobs.find_by(id: params[:make_an_offer][:job_id])
    @contract = current_user.employer_profile.contracts.create(make_an_offer_params.merge(state: 'pending'))
    close_job_if_offer_is_made
  end

  def update_contract
    @contract = current_user.employer_profile.contracts.find_by(id: params[:make_an_offer][:contract_id])
    @contract.update(update_make_an_offer_params)
  end

  def update_make_an_offer_flash_notice
    flash[:notice] = "#{@contract.state.capitalize} contract <b>#{@contract.title}</b>
                     for <b>#{@contract.freelancer_profile.full_name}</b> has been updated."
  end

  def create_make_an_offer_flash_notice
    flash[:notice] = "Your <strong>#{@contract.title}</strong> offer has been sent to
                      <strong>#{@contract.freelancer_profile.full_name}</strong>.
                      We'll send a notification when it's accepted."
  end

  def make_an_offer_params
    params.require(:make_an_offer)
          .permit(:job_id, :job_description, :title, :freelancer_profile_id, :contract_type, :pay_rate)
  end

  def update_make_an_offer_params
    params.require(:make_an_offer)
          .permit(:job_description, :title, :pay_rate, :contract_type)
  end

  def close_job_if_offer_is_made
    @job.update(state: 'closed') if params[:make_an_offer][:state] == '1'
  end

  def redirect_path_after_send_message(job_title)
    return employer_jobs_path if job_title.present?

    employer_interviews_path
  end

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
