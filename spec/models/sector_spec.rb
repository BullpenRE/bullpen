require 'rails_helper'

RSpec.describe Sector, type: :model do
  let!(:sector) { FactoryBot.create(:sector) }
  it 'factory works' do
    expect(sector).to be_valid
  end

  context 'Validations' do
    it 'description is required' do
      sector.description = ''
      expect(sector).to_not be_valid
      sector.description = nil
      expect(sector).to_not be_valid
      sector.description = 'Something Unique'
      expect(sector).to be_valid
    end

    it 'description is unique' do
      new_sector = FactoryBot.create(:sector)
      expect(new_sector).to be_valid
      new_sector.description = sector.description
      expect(new_sector).to_not be_valid
    end
  end

  context 'Relationships' do
    let(:freelancer_sector) { FactoryBot.create(:freelancer_sector, sector: sector) }

    it 'has many freelancer_sectors' do
      expect(sector.freelancer_sectors).to include(freelancer_sector)
    end

    it 'destroying an sector also destroys its associated freelancer_sectors' do
      expect(FreelancerSector.exists?(freelancer_sector.id)).to be_truthy
      sector.destroy
      expect(FreelancerSector.exists?(freelancer_sector.id)).to be_falsey
    end

    it 'has many freelancer_profiles through freelancer_sectors' do
      expect(sector.freelancer_profiles).to include(freelancer_sector.freelancer_profile)
    end
  end

end
