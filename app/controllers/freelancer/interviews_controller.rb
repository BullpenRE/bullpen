# frozen_string_literal: true

class Freelancer::InterviewsController < ApplicationController
  include LoggedInRedirects
  before_action :save_view_param_in_session,
                only: [:index], if: -> { params[:view_interview_request].present? && !user_signed_in? }
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect, :incomplete_freelancer_profile_redirect
  ITEMS_PER_PAGE = 10

  def index
    if params[:view_interview_request].present?
      index = interview_requests_collection.map(&:id).index(params[:view_interview_request].to_i)
      page = ((index + 1) / ITEMS_PER_PAGE.to_f).ceil
      @pagy, @interviews = pagy(interview_requests_collection, page: page, items: ITEMS_PER_PAGE, overflow: :last_page)
    else
      @pagy, @interviews = pagy(interview_requests_collection, items: ITEMS_PER_PAGE, overflow: :last_page)
    end

    delete_session_variable
  end

  def decline_interview
    @interview_request = current_user.freelancer_profile.interview_requests.find_by(id: params[:id])
    @interview_request.update(state: 'declined')
    EmployerMailer.interview_request_declined(@interview_request).deliver_later
  end

  def accept_request
    @interview_request = current_user.freelancer_profile.interview_requests.find_by(id: params[:id])
    @interview_request.update(state: 'accepted')
    flash[:notice] = "You have accepted an interview with <b>#{@interview_request.employer_profile.full_name}</b>. "\
                     'Select Send Message to introduce yourself and arrange a meeting.'
  end

  def remove_interview_request
    @interview_request = current_user.freelancer_profile.interview_requests.find_by(id: params[:id])
    @interview_request.update(hide_from_freelancer: true)
  end

  def send_message
    @message = Message.create(message_params)
    flash[:notice] = "Your message has been sent to <b>#{@message.to_user.full_name}</b> with you on copy."
    EmployerMailer.send_message(@message).deliver_later

    redirect_to redirect_path_after_send_message
  end

  private

  def interview_requests_collection
    @interview_requests_collection ||= current_user.freelancer_profile
                                                   .interview_requests
                                                   .not_rejected
                                                   .freelancer_visible
                                                   .order(created_at: :desc)
  end

  def save_view_param_in_session
    session[:view_interview_request] = params[:view_interview_request]

    redirect_to freelancer_interviews_path
  end

  def delete_session_variable
    session.delete(:view_interview_request)
  end

  def message_params
    {
      to_user_id: params[:message][:to_user].to_i,
      from_user: current_user,
      description: params[:message][:description]
    }
  end

    def redirect_path_after_send_message
    return freelancer_contracts_path if params.dig(:message, :redirect_reference) == 'contracts'

    freelancer_interviews_path
  end
end
