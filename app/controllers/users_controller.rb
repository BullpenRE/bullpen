# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def update

  end

  private

  def update_user_params
    params.require(:user).permit(:first_name, :last_name)
  end
end
