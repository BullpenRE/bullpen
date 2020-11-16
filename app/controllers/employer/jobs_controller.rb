# frozen_string_literal: true

class Employer::JobsController < ApplicationController
  before_action :authenticate_user!

  def index
    @jobs = current_user.jobs.order(created_at: :desc)
  end

  def destroy
    job.destroy
  end

  private

  def job
    @job ||= current_user.jobs.find_by(id: params[:id])
  end
end
