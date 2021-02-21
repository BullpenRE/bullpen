require 'rails_helper'

describe 'PopulateNewReferences' do
  let(:service) { PopulateNewReferences.new }
  let!(:freelancer_profile) { FactoryBot.create(:freelancer_profile) }
  let!(:old_job_application) { FactoryBot.create(:job_application, freelancer_profile: freelancer_profile) }

  let!(:employer_profile) { FactoryBot.create(:employer_profile) }
  let!(:old_job) { FactoryBot.create(:job, employer_profile: employer_profile) }

  before do
    old_job_application.freelancer_profile_id = nil
    old_job_application.save(validate: false)
    old_job.employer_profile_id = nil
    old_job.save(validate: false)
  end

  it 'instantiates OK' do
    expect(service).to be_present
  end

  it 'factories work' do
    expect(old_job_application.user).to eq(freelancer_profile.user)
    expect(old_job_application.freelancer_profile).to be_nil
    expect(old_job.user).to eq(employer_profile.user)
    expect(old_job.employer_profile).to be_nil
  end

  describe '#up' do
    it 'sets the job employer_profile_id and freelancer_profile_id on jobs and job_applications to that of the user' do
      service.up

      expect(old_job.reload.employer_profile).to eq(employer_profile)
      expect(old_job_application.reload.freelancer_profile).to eq(freelancer_profile)
    end
  end

end
