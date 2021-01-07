# frozen_string_literal: true

class WorkSampleController < ApplicationController

  before_action :authenticate_user!

  def update
    job_application.work_samples.attach(params[:work_sample]) if params[:work_sample].present?

    render json: { status: :ok,
                   file_name: params[:work_sample].original_filename.to_s }
  rescue StandardError
    job_application.errors.add(:base, 'File was not uploaded successfully.')
  end

  def destroy_work_sample
    return if find_blob_by_key.blank?

    find_blob_by_key.purge_later unless blob_attached?
    find_blob_by_key.attachments[0].purge_later if blob_attached?
    render json: { status: :ok }
  end

  private

  def user
    @user ||= current_user
  end

  def job_application
    @job_application ||= user.job_applications.find_by(id: params[:app_id])
  end

  def find_blob_by_key
    @find_blob_by_key ||= ActiveStorage::Blob.find_signed(params[:blob_key])
  rescue ActiveSupport::MessageVerifier::InvalidSignature => _e
    return []

  rescue ActiveRecord::RecordNotFound => _e
    render json: { status: :ok }
    @find_blob_by_key
  end

  def blob_attached?
    return false if find_blob_by_key.blank?

    find_blob_by_key.attachments.present?
  end
end
