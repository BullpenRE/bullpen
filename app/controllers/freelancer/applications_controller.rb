# frozen_string_literal: true

class Freelancer::ApplicationsController < ApplicationController
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect, :incomplete_freelancer_profile_redirect
  before_action :forward_if_no_records, only: [:index]
  ITEMS_PER_PAGE = 10

  def index
    @pagy, @job_applications = pagy(current_user.freelancer_profile
                                                .job_applications
                                                .draft_or_applied.order(created_at: :desc),
                                    items: ITEMS_PER_PAGE, overflow: :last_page)
    mixpanel_freelancer_application_tracker('Show all freelancer application')
  end

  def destroy
    mixpanel_freelancer_application_tracker('Destroy Application')
    job_application.destroy
  end

  def set_withdrawn
    mixpanel_freelancer_application_tracker('Application Withdraw')
    job_application.update(state: 'withdrawn')
    EmployerMailer.job_application_was_withdrawn(job_application).deliver_later
  end

  private

  def job_application
    @job_application ||= current_user.freelancer_profile.job_applications.find_by(id: params[:id])
  end

  def mixpanel_freelancer_application_tracker(action)
    MixpanelWorker.perform_async(current_user.id, action, { 'user': current_user.email })
  end

  def forward_if_no_records
    redirect_to freelancer_jobs_path if current_user.freelancer_profile.job_applications.draft_or_applied.blank?
  end
end
