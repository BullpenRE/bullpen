require 'rails_helper'

RSpec.describe JobSoftware, type: :model do
  let(:job) { FactoryBot.create(:job) }
  let(:software) { FactoryBot.create(:software) }
  let!(:job_software) { FactoryBot.create(:job_software, job: job, software: software) }

  it 'factory works' do
    expect(job_software).to be_valid
  end

  context 'Validations' do
    it 'the combination of its job_id and software_id must be unique' do
      duplicate = FactoryBot.create(:job_software)
      duplicate.job_id = job.id
      expect(duplicate).to be_valid
      duplicate.software_id = software.id
      expect(duplicate).to_not be_valid
    end
  end

  context 'Relationships' do
    it 'belongs to a job' do
      expect(job_software.job).to eq(job)
    end

    it 'belongs to a software' do
      expect(job_software.software).to eq(software)
    end
  end
end
