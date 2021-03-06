# frozen_string_literal: true

class Public::JobController < ApplicationController

  def show
    @job = Job.lookup(params[:slug])
    redirect_to job_not_found_path if @job.blank?
  end

  def apply_for_job
    session[:apply_for_job] = params[:apply_for_job]

    redirect_to freelancer_jobs_path
  end
end
