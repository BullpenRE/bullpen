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
    describe 'freelancer_sectors' do
      let(:freelancer_sector) { FactoryBot.create(:freelancer_sector, sector: sector) }

      it 'has many' do
        expect(sector.freelancer_sectors).to include(freelancer_sector)
      end

      it 'destroying a sector also destroys its associated freelancer_sectors' do
        expect(FreelancerSector.exists?(freelancer_sector.id)).to be_truthy
        sector.destroy
        expect(FreelancerSector.exists?(freelancer_sector.id)).to be_falsey
      end

      it 'has many freelancer_profiles through freelancer_sectors' do
        expect(sector.freelancer_profiles).to include(freelancer_sector.freelancer_profile)
      end
    end

    describe 'employer_sectors' do
      let!(:employer_sector) { FactoryBot.create(:employer_sector, sector: sector) }

      it 'has many' do
        expect(sector.employer_sectors).to include(employer_sector)
      end

      it 'destroying a sector also destroys its associated freelancer_sectors' do
        expect(EmployerSector.exists?(employer_sector.id)).to be_truthy
        sector.destroy
        expect(EmployerSector.exists?(employer_sector.id)).to be_falsey
      end

      it 'has many employer_profiles through employer_sectors' do
        expect(sector.employer_profiles).to include(employer_sector.employer_profile)
      end
    end

    describe 'job_sectors' do
      let(:job_sector) { FactoryBot.create(:job_sector, sector: sector) }

      it 'has many' do
        expect(sector.job_sectors).to include(job_sector)
      end

      it 'destroying a sector also destroys its associate job_sectors' do
        expect(JobSector.exists?(job_sector.id)).to be_truthy
        sector.destroy
        expect(JobSector.exists?(job_sector.id)).to be_falsey
      end

      it 'has many sectors through job_sectors' do
        expect(sector.jobs).to include(job_sector.job)
      end
    end
  end

  context 'Scopes' do
    it '.enabled' do
      disabled_scope = FactoryBot.create(:sector, disable: true)
      expect(sector.disable).to be_falsey
      expect(Sector.enabled).to include(sector)
      expect(Sector.enabled).to_not include(disabled_scope)
    end
  end
end
