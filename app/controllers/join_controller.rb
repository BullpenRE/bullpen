# frozen_string_literal: true

class JoinController < ApplicationController
  include RedirectPath
  def index
    return unless user.present?

    redirect_to url_for_redirect
  end
end
