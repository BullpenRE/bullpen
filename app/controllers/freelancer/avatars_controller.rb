# frozen_string_literal: true

module Freelancer
  class AvatarsController < BaseAvatarsController
    before_action :non_freelancer_redirect

    def update
      return unless valid_input_file?

      @user = current_user
      @freelancer_profile = @user.freelancer_profile
      @freelancer_profile.avatar.purge_later if @freelancer_profile.avatar.attached?
      process_and_save_new_image!(@freelancer_profile)

      render json: { status: :ok }
    rescue StandardError
      handle_rescue
    end

    def destroy
      return unless current_user.freelancer_profile.avatar.attached?

      current_user.freelancer_profile.avatar.purge_later
      render json: { status: :ok }
    end

    private

    def handle_rescue
      @freelancer_profile.avatar.purge_later
      @freelancer_profile.errors.add(:base, 'Avatar was deleted due to errors')
    end
  end
end
