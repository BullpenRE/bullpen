require 'rails_helper'

RSpec.describe FreelancerSector, type: :model do
  let(:sector) { FactoryBot.create(:sector) }
  let(:freelancer_profile) { FactoryBot.create(:freelancer_profile) }
  let!(:freelancer_sector) { FactoryBot.create(:freelancer_sector, freelancer_profile: freelancer_profile, sector: sector) }

  it 'factory works' do
    expect(freelancer_sector).to be_valid
  end

  context 'Validations' do
    it 'the combination of its freelancer_profile_id and sector_id must be unique' do
      duplicate = FactoryBot.create(:freelancer_sector)
      duplicate.freelancer_profile_id = freelancer_sector.freelancer_profile_id
      expect(duplicate.valid?).to be_truthy
      duplicate.sector_id = freelancer_sector.sector_id
      expect(duplicate.valid?).to be_falsey
    end
  end

  context 'Relationships' do
    it 'belongs_to a freelancer_profile' do
      expect(freelancer_sector.freelancer_profile).to eq(freelancer_profile)
    end

    it 'belongs_to an sector' do
      expect(freelancer_sector.sector).to eq(sector)
    end
  end
end
