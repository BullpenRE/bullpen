require 'rails_helper'

RSpec.describe JobSector, type: :model do
  let(:sector) { FactoryBot.create(:sector) }
  let(:job) { FactoryBot.create(:job) }
  let!(:job_sector) { FactoryBot.create(:job_sector, job: job, sector: sector) }

  it 'factory works' do
    expect(job_sector).to be_valid
  end

  context 'Validations' do
    it 'the combination of its freelancer_profile_id and sector_id must be unique' do
      duplicate = FactoryBot.create(:job_sector)
      duplicate.job_id = job_sector.job_id
      expect(duplicate.valid?).to be_truthy
      duplicate.sector_id = job_sector.sector_id
      expect(duplicate.valid?).to be_falsey
    end

    it 'the foreign keys cannot be blank' do
      expect(job_sector).to be_valid
      job_sector.job_id = nil
      expect(job_sector).to_not be_valid
      job_sector.job_id = job.id
      expect(job_sector).to be_valid
      job_sector.sector_id = nil
      expect(job_sector).to_not be_valid
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
