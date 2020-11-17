# frozen_string_literal: true

class Employer::JobsController < ApplicationController
  before_action :authenticate_user!

  def index
    @jobs = current_user.jobs.order(created_at: :desc)
  end

  def destroy
    job.destroy
  end

  def post_job
    job.update(state: 'posted')

    redirect_to employer_jobs_path
  end

  private

  def job
    @job ||= current_user.jobs.find_by(id: params[:id])
  end
end
