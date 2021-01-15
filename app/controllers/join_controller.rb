# frozen_string_literal: true

class JoinController < ApplicationController
  include LoggedInRedirects
  before_action :check_signed_in
  before_action :check_blank_email, :check_existing_email, only: [:signup]

  def index; end

  def signup
    redirect_to new_user_registration_path(action: :freelancer_sign_up)
  end

  private

  def check_blank_email
    return unless user_email.blank?

    flash[:notice] = I18n.t 'devise.registrations.missing_email'
    redirect_to join_path
  end

  def check_existing_email
    return unless User.find_by(email: user_email)

    flash[:notice] = I18n.t 'devise.registrations.already_exists', email: user_email, path: new_user_session_path(email: user_email)
    redirect_to join_path
  end

  def user_email
    params[:user][:email]
  end

  def check_signed_in
    redirect_to current_signup_step_url if user_signed_in?
  end
end
