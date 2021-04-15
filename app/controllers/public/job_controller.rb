# frozen_string_literal: true

class Public::JobController < ApplicationController

  def show
    @job = Job.lookup(params[:slug])

    render 'errors/job_not_found' if @job.blank? || @job.employer_profile.disabled
  end

  def apply_for_job
    session[:apply_for_job] = params[:apply_for_job]

    redirect_to freelancer_jobs_path
  end
end
