# frozen_string_literal: true

module Employer
  class AvatarController < ApplicationController
    include ImageProcessing

    before_action :authenticate_user!, :user, :employer_profile

    def update
      @employer_profile.avatar.purge_later if params[:avatar].present? && @employer_profile.avatar.attached?
      process_and_save_new_image!(@employer_profile) if params[:avatar].present?

      render json: { status: :ok }
    rescue StandardError
      @employer_profile.avatar.purge_later
      @errors.add(:base, 'Avatar was deleted due to errors')
    end

    def destroy
      return unless current_user.employer_profile.avatar.attached?

      current_user.employer_profile.avatar.purge_later
      render json: { status: :ok }
    end

    private

    def user
      @user ||= current_user
    end

    def employer_profile
      @employer_profile ||= current_user.employer_profile
    end
  end
end
