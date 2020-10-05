require 'rails_helper'

RSpec.describe FreelancerAssetClass, type: :model do
  let(:asset_class) { FactoryBot.create(:asset_class) }
  let(:freelancer_profile) { FactoryBot.create(:freelancer_profile) }
  let!(:freelancer_asset_class) { FactoryBot.create(:freelancer_asset_class, freelancer_profile: freelancer_profile, asset_class: asset_class) }

  it 'factory works' do
    expect(freelancer_asset_class).to be_valid
  end

  context 'Validations' do
    it 'the combination of its freelancer_profile_id and asset_class_id must be unique' do
      duplicate = FactoryBot.create(:freelancer_asset_class)
      duplicate.freelancer_profile_id = freelancer_asset_class.freelancer_profile_id
      expect(duplicate.valid?).to be_truthy
      duplicate.asset_class_id = freelancer_asset_class.asset_class_id
      expect(duplicate.valid?).to be_falsey
    end
  end

  context 'Relationships' do
    it 'belongs_to a freelancer_profile' do
      expect(freelancer_asset_class.freelancer_profile).to eq(freelancer_profile)
    end

    it 'belongs_to an asset_class' do
      expect(freelancer_asset_class.asset_class).to eq(asset_class)
    end
  end

end
