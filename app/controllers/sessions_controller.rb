# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  def new
    @open = params[:open]
    super
  end

  def create
    session[:open] = params[:user][:open]
    super
  end
end