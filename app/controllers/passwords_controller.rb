# frozen_string_literal: true

class PasswordsController < Devise::PasswordsController
  protected

  def after_sending_reset_password_instructions_path_for(resource_name)
    password_reset_path(resource_name)
  end

  def password_reset; end
end
