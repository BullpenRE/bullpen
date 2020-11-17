# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  include LoggedInRedirects
  before_action :configure_sign_up_params, only: [:create]
  before_action :check_signed_in
  # before_action :configure_account_update_params, only: [:update]

  def new
    if params[:action] == 'freelancer_sign_up' || params[:action] == 'employer_sign_up'
      super
    else
      redirect_to root_path
    end
  end

  def freelancer_sign_up
    show_promo_code('freelancer')
    new
  end

  def employer_sign_up
    show_promo_code('employer')
    new
  end

  def create
    insert_promo_code_id if params[:promo_code]
    super
  end

  protected

  def check_signed_in
    redirect_to current_signup_step_url if signed_in?
  end

  def after_sign_in_path_for(_resource)
    employer? ? employer_profile_steps_path(current_user) : freelancer_profile_steps_path(current_user)
  end

  def after_sign_up_path_for(_resource)
    forward_user_to_steps
  end

  def after_inactive_sign_up_path_for(_resource)
    forward_user_to_steps
  end

  def after_update_path_for(_resource)
    forward_user_to_steps
  end

  def forward_user_to_steps
    employer? ? employer_profile_steps_path : freelancer_profile_steps_path
  end

  def employer?
    params[:user][:role] == 'employer'
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name email phone_number role signup_promo_id])
  end

  def insert_promo_code_id
    signup_promo = SignupPromo.find_by(code: params[:promo_code])
    return unless signup_promo
    return if signup_promo.user_type != 'both' && signup_promo.user_type != params[:user][:role]

    params[:user][:signup_promo_id] = signup_promo.id
    session.delete(:promo_code)
  end

  def show_promo_code(user_type)
    @show_promo_code ||= SignupPromo.stillvalid.where("user_type = ? OR user_type = ?", SignupPromo.user_types[user_type], SignupPromo.user_types['both']).any?
  end
end
