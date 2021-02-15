require 'rails_helper'

describe User do
  let!(:user) { FactoryBot.create(:user) }
  let!(:employer_user) { FactoryBot.create(:user, :employer) }
  let!(:freelancer_user) { FactoryBot.create(:user, :freelancer) }

  it 'factory works' do
    expect(user).to be_valid
    expect(employer_user).to be_valid
    expect(freelancer_user).to be_valid
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
  end

  context 'Relationships' do
    let!(:freelancer_profile) { FactoryBot.create(:freelancer_profile, user: freelancer_user) }

    describe 'freelance_profile' do
      it 'can have one' do
        expect(freelancer_user.freelancer_profile).to eq(freelancer_profile)
      end

      it 'destroying a user destroys its freelance_profile' do
        expect(FreelancerProfile.exists?(freelancer_profile.id)).to be_truthy
        freelancer_user.destroy
        expect(FreelancerProfile.exists?(freelancer_profile.id)).to be_falsey
      end

      it { should belong_to(:signup_promo).optional }
    end

    describe 'jobs' do
      let!(:job) { FactoryBot.create(:job, user: employer_user) }
      it 'has many' do
        expect(employer_user.jobs).to include(job)
      end

      it 'dependent destroy' do
        employer_user.destroy
        expect(Job.exists?(job.id)).to be_falsey
      end
    end

    describe 'freelancer_sectors and freelancer_real_estate_skills' do
      let(:sector) { FactoryBot.create(:sector, description: 'Special Sector') }
      let(:real_estate_skill) { FactoryBot.create(:real_estate_skill, description: 'Special Real Estate Skill') }
      let!(:freelancer_sector) { FactoryBot.create(:freelancer_sector, freelancer_profile: freelancer_profile, sector: sector) }
      let!(:freelancer_real_estate_skill) { FactoryBot.create(:freelancer_real_estate_skill, freelancer_profile: freelancer_profile, real_estate_skill: real_estate_skill) }

      it 'can have many through the freelance_profile' do
        expect(freelancer_user.freelancer_sectors).to include(freelancer_sector)
        expect(freelancer_user.freelancer_real_estate_skills).to include(freelancer_real_estate_skill)
      end
    end

    describe 'job_applications' do
      let!(:job_application) { FactoryBot.create(:job_application, user: freelancer_user) }
      it 'has many job_applications with dependent destroy' do
        expect(freelancer_user.job_applications).to include(job_application)
        freelancer_user.destroy
        expect(JobApplication.exists?(job_application.id)).to be_falsey
      end
    end

    describe 'messages' do
      let!(:sent_message) { FactoryBot.create(:message, from_user: user) }
      let!(:received_message) { FactoryBot.create(:message, to_user: user) }

      it 'can have many sent_messages and received_messages' do
        expect(user.sent_messages).to include(sent_message)
        expect(user.received_messages).to include(received_message)
      end
    end
  end

  context 'Scopes' do
    let!(:confirmed) { FactoryBot.create(:user, confirmed_at: 3.days.ago) }
    let!(:not_confirmed) { FactoryBot.create(:user, confirmed_at: nil) }
    let!(:freelancer_profile) { FactoryBot.create(:freelancer_profile, user: freelancer_user) }
    let!(:employer_profile) { FactoryBot.create(:employer_profile, user: employer_user) }

    it '.confirmed' do
      expect(User.confirmed).to include(confirmed)
      expect(User.confirmed).to_not include(not_confirmed)
    end

    it '.no_freelancer_data' do
      expect(User.no_freelancer_data).to include(user)
      expect(User.no_freelancer_data).to include(employer_user)
      expect(User.no_freelancer_data).to_not include(freelancer_user)
    end

    it '.no_employer_data' do
      expect(User.no_employer_data).to include(user)
      expect(User.no_employer_data).to include(freelancer_user)
      expect(User.no_employer_data).to_not include(employer_user)
    end

    it '.employers' do
      expect(User.employers).to include(employer_user)
      expect(User.employers).to_not include(freelancer_user)
    end
  end

  context 'geocode' do
    it 'writes latitude and longitude fields during user creation using location as argument' do
      expect(freelancer_user.location).to eq('New York, NY') # geocoder argument
      expect(freelancer_user.latitude).to eq(40.7127281) # data from stub to prevent API call
      expect(freelancer_user.longitude).to eq(-74.0060152)
    end

    it 'updates latitude and longitude fields if location was changed' do
      freelancer_user.update(location: 'San Francisco, CA')
      freelancer_user.reload

      expect(freelancer_user.location).to eq('San Francisco, CA')
      expect(freelancer_user.latitude).not_to eq(40.7127281)
      expect(freelancer_user.longitude).not_to eq(-74.0060152)
    end
  end
end
