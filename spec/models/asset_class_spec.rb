require 'rails_helper'

RSpec.describe AssetClass, type: :model do
  let!(:asset_class) { FactoryBot.create(:asset_class) }
  it 'factory works' do
    expect(asset_class).to be_valid
  end

  context 'validations' do
    it 'description is required' do
      asset_class.description = ''
      expect(asset_class).to_not be_valid
      asset_class.description = nil
      expect(asset_class).to_not be_valid
      asset_class.description = 'Something Unique'
      expect(asset_class).to be_valid
    end

    it 'description is unique' do
      new_asset_class = FactoryBot.create(:asset_class)
      expect(new_asset_class).to be_valid
      new_asset_class.description = asset_class.description
      expect(new_asset_class).to_not be_valid
    end
  end
end
