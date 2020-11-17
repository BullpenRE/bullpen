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
    let!(:freelancer_software) { FactoryBot.create(:freelancer_software, software: software) }
    let!(:freelancer_profile) { freelancer_software.freelancer_profile }

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

    it 'has many freelancer_softwares' do
      expect(software.freelancer_softwares).to include(freelancer_software)
    end

    it 'has many freelancer_profiles through freelancer_software' do
      expect(software.freelancer_profiles).to include(freelancer_profile)
    end

    it 'freelancer_softwares are dependent destroyed, freelancer_profiles are not' do
      software.destroy
      expect(FreelancerSoftware.exists?(freelancer_software.id)).to be_falsey
      expect(FreelancerProfile.exists?(freelancer_profile.id)).to be_truthy
    end
  end

  context 'Scopes' do
    it '.enabled' do
      disabled_software = FactoryBot.create(:software, disable: true)
      expect(software.disable).to be_falsey
      expect(Software.enabled).to include(software)
      expect(Software.enabled).to_not include(disabled_software)
    end
  end

end
