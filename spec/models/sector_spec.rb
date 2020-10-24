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
      new_sector.description = sector.description
      expect(new_sector).to_not be_valid
    end

    context 'Relationships' do
      let!(:job_sector) { FactoryBot.create(:job_sector, sector: sector) }
      let!(:job) { job_sector.job }

      it 'has many job_sectors' do
        expect(sector.job_sectors).to include(job_sector)
      end

      it 'has many jobs through job_sectors' do
        expect(sector.jobs).to include(job)
      end

      it 'job_sectors are dependent destroy and jobs are not' do
        sector.destroy
        expect(JobSector.exists?(job_sector.id)).to be_falsey
        expect(Job.exists?(job.id)).to be_truthy
      end
    end
  end
end
