# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :check_signed_in

  def new
    return redirect_to root_path unless session[:email].present?

    @email = session[:email]
    show_promo_code

    super
  end

  def edit
    @hide_password_section = user_signed_in?
    show_promo_code

    render 'devise/registrations/new'
  end

  def create
    insert_promo_code_id if params[:promo_code]
    session.delete(:email)

    super
  end

  def update
    insert_promo_code_id if params[:promo_code]
    current_user.update(google_signup_params)

    redirect_to forward_user_to_steps
  end

  protected

  def check_signed_in
    redirect_to current_signup_step_url if signed_in? && current_user.role.present?
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
    current_user&.role == 'employer' || (params[:user] && params[:user][:role] == 'employer')
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

  def show_promo_code
    @show_promo_code ||= SignupPromo.stillvalid.any?
  end

  private

  def google_signup_params
    params.require(:user).permit(:first_name, :last_name, :phone_number, :role, :signup_promo_id)
  end
end
