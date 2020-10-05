require 'rails_helper'

RSpec.describe FreelancerAssetClass, type: :model do
  let!(:freelancer_asset_class) { FactoryBot.create(:freelancer_asset_class) }

  it 'factory works' do
    expect(freelancer_asset_class).to be_valid
  end
end
