require 'rails_helper'

RSpec.describe Sector, type: :model do
  let!(:sector) { FactoryBot.create(:sector) }
  it 'factory works' do
    expect(sector).to be_valid
  end

  context 'Validations' do
    it 'description is unique' do
      new_sector = FactoryBot.create(:sector)
      expect(new_sector).to be_valid
      new_sector.sector_description = sector.sector_description
      expect(new_sector).to_not be_valid
    end
  end

  context 'Relationships' do
    let!(:employer_profile_sector) { FactoryBot.create(:employer_profile_sector, sector: sector) }
    it 'has many employer_profile_sectors' do
      expect(sector.employer_profile_sectors).to include(employer_profile_sector)
    end

    it 'has many employer_profiles through employer_profile_sector' do
      expect(sector.employer_profile_sectors).to include(employer_profile_sector)
    end
  end
end
