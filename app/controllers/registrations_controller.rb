# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  def new
    super
  end

  def create
    super
  end

  def update
    super
  end

  protected

  def after_sign_in_path_for(resource)
    registration_steps_path(current_user)
  end

  def after_sign_up_path_for(resource)
    registration_steps_path
  end

  def after_inactive_sign_up_path_for(resource)
    registration_steps_path
  end

  def after_update_path_for(resource)
    registration_steps_path
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  #

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name email])
  end
end
