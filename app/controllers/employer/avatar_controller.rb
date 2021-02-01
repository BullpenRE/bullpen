# frozen_string_literal: true

module Employer
  class AvatarController < ApplicationController
    before_action :authenticate_user!, :user, :employer_profile

    def update
      return unless params[:avatar].present?

      create_image

      render json: { status: :ok }
    rescue StandardError
      employer_profile.avatar.purge_later
      employer_profile.errors.add(:base, 'Avatar was deleted due to errors')
    end

    def destroy
      return unless employer_profile.avatar.attached?

      employer_profile.avatar.purge_later
      render json: { status: :ok }
    end

    private

    def user
      @user ||= current_user
    end

    def employer_profile
      @employer_profile ||= current_user.employer_profile
    end

    def create_image
      employer_profile.avatar.purge_later if employer_profile.avatar.attached?
      process_and_save_new_image!(params.require(:avatar).path)
    end

    def process_and_save_new_image!(path)
      image = MiniMagick::Image.open(path)
      image_service = AvatarFormatService.new(image)
      image_service.convert
      file = File.open(image_service.image.path)
      employer_profile.avatar.attach(io: file, filename: File.basename(image.path), content_type: 'image/jpg')
    end
  end
end
