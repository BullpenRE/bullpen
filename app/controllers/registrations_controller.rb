# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

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
    if promo_code_execute? && promo_exist?
      set_promo_freelancer
    else
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name email role])
    end
  end
  
  def employer_params
    if promo_code_execute? && promo_exist?
      set_promo_employer
    else
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name email phone_number role])
    end
  end

  def promo_code_execute?
    session[:promo_code].present?
  end

  def promo_exist?
    promo_code.present?
  end

  def promo_code
    @promo_code ||= SignupPromo.find_by(code: session[:promo_code])
  end

  def set_promo_employer
    params[:user].merge!(:signup_promo_id => promo_code.id.to_s)
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name email phone_number role signup_promo_id])
  end

  def set_promo_freelancer
    params[:user].merge!(:signup_promo_id => promo_code.id.to_s)
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name email role signup_promo_id])
  end

end
