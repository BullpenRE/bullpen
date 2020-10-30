# frozen_string_literal: true

class EmployerController < ApplicationController
  before_action :authenticate_user!
  before_action :completed_profile

  def index
  end

  def show
  end

  private

  def completed_profile
    current_user.employer? && current_user.employer_profile.completed?
  end
end
