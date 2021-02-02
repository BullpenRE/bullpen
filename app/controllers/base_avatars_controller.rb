# frozen_string_literal: true

class BaseAvatarsController < ApplicationController
  before_action :authenticate_user!, :initial_check

  private

  def process_and_save_new_image!(object)
    image = MiniMagick::Image.open(params.require(:avatar).path)
    service = AvatarFormatService.new(image)
    service.convert
    converted_image = service.image
    file = File.open(converted_image.path)
    object.avatar.attach(io: file, filename: File.basename(image.path), content_type: 'image/jpg')
  end
end
