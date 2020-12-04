# frozen_string_literal: true

class WorkSampleController < ApplicationController

  before_action :authenticate_user!

  def update
    @user = current_user
    @job_application = @user.job_applications.find_by(id: params[:app_id])
    @job_application.work_sample.purge_later if params[:work_sample].present? && @job_application.work_sample.attached?
    @job_application.work_sample.attach(params[:work_sample]) if params[:work_sample].present?

    render json: { status: :ok }
  rescue StandardError
    @job_app.work_sample.purge_later
    @errors.add(:base, 'File did not attach')
  end

  def destroy
    # return unless current_user.freelancer_profile.avatar.attached?
    #
    # current_user.freelancer_profile.avatar.purge_later
    # render json: { status: :ok }
  end
end
