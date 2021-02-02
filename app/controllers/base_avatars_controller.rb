# frozen_string_literal: true

class BaseAvatarsController < ApplicationController
  before_action :authenticate_user!, :initial_check

  private

  MAX_FILE_SIZE = 2_097_152
  ACCEPTABLE_CONTENT_TYPE = %w[image/jpg image/jpeg image/png image/gif].freeze

  def content_type_valid?
    params.require(:avatar).content_type.in? ACCEPTABLE_CONTENT_TYPE
  end

  def correct_size?
    params.require(:avatar).size < MAX_FILE_SIZE
  end

  def valid_input_file?
    return false unless params[:avatar].present?
    return true if content_type_valid? && correct_size?

    render json: { status: :ok, message: !content_type_valid? ? 'Invalid content type' : 'Too big file size' }
    false
  end

  def process_and_save_new_image!(object)
    image = MiniMagick::Image.open(params.require(:avatar).path)
    service = AvatarFormatService.new(image)
    service.convert
    converted_image = service.image
    file = File.open(converted_image.path)
    object.avatar.attach(io: file, filename: File.basename(image.path), content_type: 'image/jpg')
  end
end
