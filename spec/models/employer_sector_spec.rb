require 'rails_helper'

RSpec.describe EmployerSector, type: :model do
  let(:employer_profile) { FactoryBot.create(:employer_profile) }
  let(:sector) { FactoryBot.create(:sector) }
  let!(:employer_sector) { FactoryBot.create(:employer_sector, employer_profile: employer_profile, sector: sector) }

  it 'factory works' do
    expect(employer_sector).to be_valid
  end

  context 'Validations' do
    it 'the combination of employer_profile_id and sector_id must be unique' do
      duplicate = FactoryBot.create(:employer_sector)
      duplicate.employer_profile_id = employer_sector.employer_profile_id
      expect(duplicate.valid?).to be_truthy
      duplicate.sector_id = employer_sector.sector_id
      expect(duplicate.valid?).to be_falsey
    end
  end

  context 'Relationships' do
    it 'belongs_to a employer_profile' do
      expect(employer_sector.employer_profile).to eq(employer_profile)
    end

    it 'belongs_to a sector' do
      expect(employer_sector.sector).to eq(sector)
    end
  end
end
