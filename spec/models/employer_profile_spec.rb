require 'rails_helper'

RSpec.describe EmployerProfile, type: :model do
  let(:user)  { FactoryBot.create(:user) }
  let!(:employer_profile) { FactoryBot.create(:employer_profile, user: user) }

  it 'factory works' do
    expect(employer_profile).to be_valid
  end

  context 'Validations'

  context 'Relationships' do
    it 'belongs_to a user' do
      expect(employer_profile.user).to eq(user)
    end

    context 'employer_sectors' do
      let!(:employer_sector) { FactoryBot.create(:employer_sector, employer_profile: employer_profile) }

      it 'can have many employer_sectors' do
        expect(employer_profile.employer_sectors).to include(employer_sector)
      end

      it 'getting destroyed destroys employer_sectors' do
        expect(EmployerSector.exists?(employer_sector.id)).to be_truthy

        employer_profile.destroy

        expect(EmployerSector.exists?(employer_sector.id)).to be_falsey
      end

      it 'can have sectors through employer_sectors' do
        expect(employer_profile.sectors).to include(employer_sector.sector)
      end
    end
  end

  context 'Methods'
end
