require 'rails_helper'

RSpec.describe Software, type: :model do
  let!(:software) { FactoryBot.create(:software) }

  it 'factory works' do
    expect(software).to be_valid
  end

  context 'Validations' do
    it 'description is unique and required' do
      new_software = FactoryBot.create(:software)
      expect(new_software).to be_valid
      new_software.description = software.description
      expect(new_software).to_not be_valid
      software.description = ''
      expect(software).to_not be_valid
    end
  end

  context 'Relationships' do
    let!(:job_software) { FactoryBot.create(:job_software, software: software) }
    let!(:job) { job_software.job }
    let!(:freelancer_software) { FactoryBot.create(:freelancer_software, software: software) }
    let!(:freelancer_profile) { freelancer_software.freelancer_profile }

    it 'has many job_softwares dependent destroy' do
      expect(software.job_softwares).to include(job_software)
      software.destroy
      expect(JobSoftware.exists?(job_software.id)).to be_falsey
      expect(Job.exists?(job.id)).to be_truthy
    end

    it 'has many jobs through job_softwares' do
      expect(software.jobs).to include(job)
    end

    it 'has many freelancer_softwares dependent destroy' do
      expect(software.freelancer_softwares).to include(freelancer_software)
      software.destroy
      expect(FreelancerSoftware.exists?(freelancer_software.id)).to be_falsey
      expect(FreelancerProfile.exists?(freelancer_profile.id)).to be_truthy
    end

    it 'has many freelancer_profiles through freelancer_software' do
      expect(software.freelancer_profiles).to include(freelancer_profile)
    end
  end

  context 'Scopes' do
    describe 'default_scope' do
      it 'orders by description alphabetically' do
        ('A'..'Z').to_a.each { |letter| FactoryBot.create(:software, description: "#{letter} Software") }
        expect(Software.all.pluck(:description)).to match(Software.order(description: :asc).pluck(:description))
      end
    end
    it '.enabled' do
      disabled_software = FactoryBot.create(:software, disable: true)
      expect(software.disable).to be_falsey
      expect(Software.enabled).to include(software)
      expect(Software.enabled).to_not include(disabled_software)
    end
  end

end
