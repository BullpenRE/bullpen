# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :check_signed_in
  # before_action :configure_account_update_params, only: [:update]
  include RedirectPath

  def new
    if params[:action] == 'freelancer_sign_up' || params[:action] == 'employer_sign_up'
      super
    else
      redirect_to root_path
    end
  end

  def freelancer_sign_up
    new
  end

  def employer_sign_up
    new
  end

  def create
    super
  end

  def update
    super
  end

  protected

  def check_signed_in
    redirect_to url_for_redirect if signed_in?
  end

  def after_sign_in_path_for(resource)
    employer? ? employer_profile_steps_path(current_user) : freelancer_profile_steps_path(current_user)
  end

  def after_sign_up_path_for(resource)
    employer? ? employer_profile_steps_path : freelancer_profile_steps_path
  end

  def after_inactive_sign_up_path_for(resource)
    employer? ? employer_profile_steps_path : freelancer_profile_steps_path
  end

  def after_update_path_for(resource)
    employer? ? employer_profile_steps_path : freelancer_profile_steps_path
  end

  def employer?
    params[:user][:role] == 'employer'
  end

  def configure_sign_up_params
    employer? ? employer_params : freelancer_params
  end

  def freelancer_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name email role])
  end

  def employer_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name email phone_number role])
  end
end
