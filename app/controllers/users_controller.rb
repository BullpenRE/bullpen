# frozen_string_literal: true

class UsersController < ApplicationController
  include LoggedInRedirects

  before_action :authenticate_user!, :initial_check

  def update
    if current_user.update(update_user_params)
      redirect_to employer_account_index_path, flash: {
        notice: 'Account was updated successfully'
      }
    else
      redirect_to employer_account_index_path, flash: {
        alert: 'Account was not updated due errors'
      }
    end
  end

  private

  def update_user_params
    params.require(:user).permit(:first_name, :last_name)
  end
end
