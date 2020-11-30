# frozen_string_literal: true

class Employer::JobsController < ApplicationController
  include LoggedInRedirects
  before_action :authenticate_user!, :initial_check, :non_employer_redirect, :incomplete_employer_profile_redirect

  def index
    @pagy, @jobs = pagy(current_user.jobs.order(created_at: :desc), items: 10)
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
