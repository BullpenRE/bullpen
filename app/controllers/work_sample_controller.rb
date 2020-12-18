# frozen_string_literal: true

class WorkSampleController < ApplicationController

  before_action :authenticate_user!

  def update
    job_application.work_sample.purge_later if params[:work_sample].present? && job_application.work_sample.attached?
    job_application.work_sample.attach(params[:work_sample]) if params[:work_sample].present?

    render json: { status: :ok,
                   file_name: @job_application.work_sample.filename.to_s
                 }
  rescue StandardError
    job_application.work_sample.purge_later
    @errors.add(:base, 'File was not uploaded successfully.')
  end

  def destroy_work_sample
    return unless job_application.work_sample.attached?

    job_application.work_sample.purge_later

    render json: { status: :ok }
  end

  private

  def user
    @user ||= current_user
  end

  def job_application
    @job_application ||= user.job_applications.find_by(id: params[:app_id])
  end
end
