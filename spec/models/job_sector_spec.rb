require 'rails_helper'

RSpec.describe JobSector, type: :model do
  let(:job) { FactoryBot.create(:job) }
  let(:sector) { FactoryBot.create(:sector) }
  let!(:job_sector) { FactoryBot.create(:job_sector, job: job, sector: sector) }

  it 'factory works' do
    expect(job_sector).to be_valid
  end

  context 'Validations' do
    it 'the combination of its job_id and software_id must be unique' do
      duplicate = FactoryBot.create(:job_sector)
      duplicate.job_id = job.id
      expect(duplicate).to be_valid
      duplicate.sector_id = sector.id
      expect(duplicate).to_not be_valid
    end
  end

  context 'Relationships' do
    it 'belongs to a job' do
      expect(job_sector.job).to eq(job)
    end

    it 'belongs to a sector' do
      expect(job_sector.sector).to eq(sector)
    end
  end
end
