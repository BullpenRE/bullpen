# frozen_string_literal: true

class AvatarController < ApplicationController

  before_action :authenticate_user!

  def update
    @user = current_user
    @freelancer_profile = @user.freelancer_profile
    destroy_obsolete_avatar! if params[:avatar].present? && @freelancer_profile.avatar.attached?
    process_and_save_new_image! if params[:avatar].present?

    render json: { status: :ok }
  rescue StandardError
    @freelancer_profile.avatar.purge_later
    @errors.add(:base, 'Avatar deleted due errors')
  end

  def destroy
    return unless current_user.freelancer_profile.avatar.attached?

    current_user.freelancer_profile.avatar.purge_later
    render json: { status: :ok }
  end

  private

  def destroy_obsolete_avatar!
    find_blob.purge_later unless find_blob.attachments[0].present?
    find_blob.attachments[0].purge_later if find_blob.attachments[0].present?
  end

  def process_and_save_new_image!
    image = MiniMagick::Image.open(params.require(:avatar).path)
    service = AvatarFormatService.new(image)
    service.convert
    converted_image = service.image
    file = File.open(converted_image.path)
    @freelancer_profile.avatar.attach(io: file, filename: File.basename(image.path), content_type: 'image/jpg')
  end

  def find_blob
    @find_blob ||= @freelancer_profile.avatar.blob
  end
end
