require 'rails_helper'

RSpec.describe AssetClass, type: :model do
  let!(:asset_class) { FactoryBot.create(:asset_class) }
  it 'factory works' do
    expect(asset_class).to be_valid
  end

  context 'Validations' do
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

  context 'Relationships' do
    let(:freelancer_asset_class) { FactoryBot.create(:freelancer_asset_class, asset_class: asset_class) }

    it 'has many freelancer_asset_classes' do
      expect(asset_class.freelancer_asset_classes).to include(freelancer_asset_class)
    end

    it 'destroying an asset_class also destroys its associated freelancer_asset_classes' do
      expect(FreelancerAssetClass.exists?(freelancer_asset_class.id)).to be_truthy
      asset_class.destroy
      expect(FreelancerAssetClass.exists?(freelancer_asset_class.id)).to be_falsey
    end

    it 'has many freelancer_profiles through freelancer_asset_classes' do
      expect(asset_class.freelancer_profiles).to include(freelancer_asset_class.freelancer_profile)
    end
  end

end
