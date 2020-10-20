require 'rails_helper'

RSpec.describe AvatarFormatService do
  let(:landscape_image) { MiniMagick::Image.open(Rails.root.join('spec', 'support', 'assets', 'test_cropping_image_landscape.png')) }
  let(:portrait_image) { MiniMagick::Image.open(Rails.root.join('spec', 'support', 'assets', 'test_cropping_image_portrait.png')) }
  let(:square_image) { MiniMagick::Image.open(Rails.root.join('spec', 'support', 'assets', 'test_cropping_image_square.png')) }

  let(:landscape_service) { AvatarFormatService.new(landscape_image) }
  let(:portrait_service) { AvatarFormatService.new(portrait_image) }
  let(:square_service) { AvatarFormatService.new(square_image) }

  describe 'unit tests' do
    context 'correctly determines image proportions' do
      it 'identification support methods work as expected' do
        expect(landscape_image.width).to be > landscape_image.height
        expect(landscape_service.send(:landscape?)).to be_truthy
        expect(landscape_service.send(:portrait?)).to be_falsey
        expect(landscape_service.send(:square?)).to be_falsey
      end
    end

    context 'cropping' do
      context 'calculates crop offsets properly' do
        it 'for landscapes' do
          x_offset = (landscape_image.width - landscape_image.height)/2
          expect(landscape_service.send(:offset_x)).to eq(x_offset.to_i)
          expect(landscape_service.send(:offset_y)).to eq(0)
        end

        it 'for portraits' do
          y_offset = (portrait_image.height - portrait_image.width)/2
          expect(portrait_service.send(:offset_x)).to eq(0)
          expect(portrait_service.send(:offset_y)).to eq(y_offset.to_i)
        end

        it 'for squares' do
          expect(square_service.send(:offset_x)).to eq(0)
          expect(square_service.send(:offset_y)).to eq(0)
        end
      end

      it 'the new width and height after cropping will be set to whichever is lesser starting out' do
        expect(landscape_service.send(:crop_to_width_and_height)).to eq(landscape_image.height)
        expect(portrait_service.send(:crop_to_width_and_height)).to eq(portrait_image.width)
        expect(square_service.send(:crop_to_width_and_height)).to eq(square_image.width)
        expect(square_service.send(:crop_to_width_and_height)).to eq(square_image.height)
      end

      context 'crops to square' do
        it 'landscape image' do
          expect(landscape_service.send(:square?)).to be_falsey
          landscape_service.crop!
          expect(landscape_service.send(:square?)).to be_truthy
        end

        it 'portrait image' do
          expect(portrait_service.send(:square?)).to be_falsey
          portrait_service.crop!
          expect(portrait_service.send(:square?)).to be_truthy
        end

        it 'square images do not break' do
          expect(square_service.send(:square?)).to be_truthy
          square_service.crop!
          expect(square_service.send(:square?)).to be_truthy
        end
      end
    end

    it 'converts to jpg properly' do
      expect(square_service.image.type).to_not eq('JPG')
      square_service.convert_to_jpg!
      expect(square_service.image.type).to eq('JPEG')
    end

    it 'scales to 96x96 properly' do
      expect(square_service.image.width).to_not eq(150)
      square_service.scale!
      expect(square_service.image.width).to eq(150)
      expect(square_service.image.height).to eq(150)
    end
  end

  describe 'integration tests' do
    it 'landscape image' do
      image = landscape_service.convert
      expect(image.type).to eq('JPEG')
      expect(image.width).to eq(150)
      expect(image.height).to eq(150)
    end

    it 'portrait image' do
      image = portrait_service.convert
      expect(image.type).to eq('JPEG')
      expect(image.width).to eq(150)
      expect(image.height).to eq(150)
    end

    it 'square image' do
      image = square_service.convert
      expect(image.type).to eq('JPEG')
      expect(image.width).to eq(150)
      expect(image.height).to eq(150)
    end
  end

end