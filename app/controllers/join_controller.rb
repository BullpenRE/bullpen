# frozen_string_literal: true

class JoinController < ApplicationController
  before_action :check_signed_in
  before_action :check_blank_email, :check_existing_email, :check_valid_email, only: [:signup]

  def index
    @email = params[:email]
  end

  def signup
    session[:email] = user_email

    redirect_to new_user_registration_path
  end

  private

  def check_blank_email
    return unless user_email.blank?

    flash[:notice] = I18n.t 'devise.registrations.missing_email'
    redirect_to join_path
  end

  def check_existing_email
    return unless User.find_by(email: user_email).present?

    flash[:notice] = I18n.t('devise.registrations.already_exists',
                            email: user_email,
                            path: new_user_session_path(email: user_email))

    redirect_to join_path
  end

  def check_valid_email
    return if user_email.match?(Devise.email_regexp)

    flash[:notice] = I18n.t('devise.registrations.invalid_email', email: user_email)

    redirect_to join_path
  end

  def user_email
    params[:user][:email]
  end

  def check_signed_in
    redirect_to current_signup_step_url if user_signed_in?
  end
end
