# frozen_string_literal: true

module Employer
  class AvatarsController < BaseAvatarsController
    include LoggedInRedirects
    before_action :non_employer_redirect

    def update
      return unless valid_input_file?

      @user = current_user
      @employer_profile = @user.employer_profile
      @employer_profile.avatar.purge_later if @employer_profile.avatar.attached?
      process_and_save_new_image!(@employer_profile)

      render json: { status: :ok }
    rescue StandardError
      handle_rescue
    end

    def destroy
      return unless current_user.employer_profile.avatar.attached?

      current_user.employer_profile.avatar.purge_later
      render json: { status: :ok }
    end

    private

    def handle_rescue
      @employer_profile.avatar.purge_later
      @employer_profile.errors.add(:base, 'Avatar was deleted due to errors')
    end
  end
end
