# frozen_string_literal: true

class RegistrationStepsController < ApplicationController
  include Wicked::Wizard
  steps :password, :other_step

  def show
    @user = current_user
    render_wizard
  end

  def update
    @user = current_user
    @user.attributes = params[:user]
    render_wizard @user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
