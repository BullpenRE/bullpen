# frozen_string_literal: true

class Employer::JobsController < ApplicationController
  before_action :authenticate_user!

  def index
    @jobs = current_user.jobs.order(created_at: :desc)
  end
end
