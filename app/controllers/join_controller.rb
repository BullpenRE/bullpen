# frozen_string_literal: true

class JoinController < ApplicationController
  include RedirectPath
  before_action :check_signed_in

  def index; end

  def check_signed_in
    redirect_to url_for_redirect if signed_in?
  end
end
