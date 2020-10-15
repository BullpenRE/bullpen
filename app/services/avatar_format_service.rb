# frozen_string_literal: true

class AvatarFormatService

  AVATAR_SAVE_DIMENSIONS = '150x150'.freeze

  attr_accessor :image

  def initialize(image)
    @image = image
  end

  def convert
    orient!
    crop!
    scale!
    convert_to_jpg!

    @image
  end

  def orient!
    @image.auto_orient
  end

  def crop!
    return if square?

    @image.crop "#{crop_to_width_and_height}x#{crop_to_width_and_height}+#{offset_x}+#{offset_y}"
  end

  def convert_to_jpg!
    @image.format('jpg')
  end

  def scale!
    @image.resize AVATAR_SAVE_DIMENSIONS
  end

  private

  def offset_x
    return 0 unless landscape?

    ((@image.width - @image.height) / 2).to_i
  end

  def offset_y
    return 0 unless portrait?

    ((@image.height - @image.width) / 2).to_i
  end

  def crop_to_width_and_height
    return @image.width.to_i if portrait?

    @image.height.to_i
  end

  def landscape?
    @image.width.to_i > @image.height.to_i
  end

  def portrait?
    @image.height.to_i > @image.width.to_i
  end

  def square?
    !landscape? && !portrait?
  end
end
