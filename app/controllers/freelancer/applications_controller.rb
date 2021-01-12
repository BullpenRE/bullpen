# frozen_string_literal: true

class Freelancer::ApplicationsController < ApplicationController
  include LoggedInRedirects
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect, :incomplete_freelancer_profile_redirect
  ITEMS_PER_PAGE = 10

  def index
    @pagy, @job_applications = pagy(current_user.job_applications.order(created_at: :desc), items: ITEMS_PER_PAGE, overflow: :last_page)
  end

  def destroy
    job_application.destroy
    job_application_draft_was_deleted_flash_notice!
  end

  def set_withdrawn
    job_application.update(state: 'withdrawn')
    EmployerMailer.job_application_was_withdrawn(job_application).deliver_now
    job_application_was_withdrawn_flash_notice!
  end

  private

  def job_application
    @job_application ||= current_user.job_applications.find_by(id: params[:id])
  end

  def job_application_draft_was_deleted_flash_notice!
    flash[:notice] = '<i class="far fa-check-circle"></i> <strong> Success!</strong> '\
                     "Job application for #{job_application.job.title.capitalize} was deleted."
  end

  def job_application_was_withdrawn_flash_notice!
    flash[:notice] = '<i class="far fa-check-circle"></i> <strong> Success!</strong> '\
                     "Job application for #{job_application.job.title.capitalize} was withdrawn."
  end
end
