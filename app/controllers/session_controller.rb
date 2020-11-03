# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  def create
    byebug
    session[:current_user_id] = @user.id
  end
end