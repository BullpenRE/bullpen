# frozen_string_literal: true

class JoinController < ApplicationController
  include LoggedInRedirects
  before_action :check_signed_in

  def index; end

  def signup
    if User.find_by(email: user_email)
      flash[:alert] = I18n.t 'devise.registrations.already_exists', email: user_email, path: new_user_session_path
    end

    redirect_to join_path
  end

  private

  def user_email
    params[:user][:email]
  end

  def check_signed_in
    redirect_to current_signup_step_url if user_signed_in?
  end
end
