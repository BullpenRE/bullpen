# frozen_string_literal: true

class Freelancer::AccountController < ApplicationController
  before_action :authenticate_user!

  def index
    freelancer_profile
    @sectors = Sector.enabled.pluck(:description, :id)
  end

  private

  def freelancer_profile
    @freelancer_profile ||= current_user.freelancer_profile
  end
end
