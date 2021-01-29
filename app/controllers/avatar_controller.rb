# frozen_string_literal: true

class AvatarController < ApplicationController
  include ImageProcessing

  before_action :authenticate_user!, :user, :freelancer_profile

  def update
    @freelancer_profile.avatar.purge_later if params[:avatar].present? && @freelancer_profile.avatar.attached?
    process_and_save_new_image!(@freelancer_profile) if params[:avatar].present?

    render json: { status: :ok }
  rescue StandardError
    @freelancer_profile.avatar.purge_later
    @errors.add(:base, 'Avatar was deleted due to errors')
  end

  def destroy
    return unless current_user.freelancer_profile.avatar.attached?

    current_user.freelancer_profile.avatar.purge_later
    render json: { status: :ok }
  end

  private

  def user
    @user ||= current_user
  end

  def freelancer_profile
    @freelancer_profile ||= current_user.employer_profile
  end
end
