# frozen_string_literal: true

class Cypress::SessionsController < ActionController::Base
  def create
    sign_in(user)
    render json: user
  end

  private

  def user
    User.find_by(email: params[:email]) || User.first
  end
end
