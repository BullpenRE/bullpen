require 'rails_helper'

RSpec.describe Software, type: :model do
  let!(:software) { FactoryBot.create(:software) }

  it 'factory works' do
    expect(software).to be_valid
  end

  context 'Validations' do
    it 'description is unique' do
      new_software = FactoryBot.create(:software)
      expect(new_software).to be_valid
      new_software.description = software.description
      expect(new_software).to_not be_valid
    end
  end

  context 'Relationships' do
    let!(:job_software) { FactoryBot.create(:job_software, software: software) }
    let!(:job) { job_software.job }

    it 'has many job_softwares' do
      expect(software.job_softwares).to include(job_software)
    end

    it 'has many jobs through job_softwares' do
      expect(software.jobs).to include(job)
    end

    it 'job_softwares are dependent destroyed, jobs are not' do
      software.destroy
      expect(JobSoftware.exists?(job_software.id)).to be_falsey
      expect(Job.exists?(job.id)).to be_truthy
    end
  end

end
