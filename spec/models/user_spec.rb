require 'rails_helper'

describe User do
  let!(:user) { FactoryBot.create(:user) }

  it 'factory works' do
    expect(user).to be_valid
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
  end

  context 'Relationships' do
    let!(:freelancer_profile) { FactoryBot.create(:freelancer_profile, user: user) }

    describe 'freelance_profile' do
      it 'can have one' do
        expect(user.freelancer_profile).to eq(freelancer_profile)
      end

      it 'destroying a user destroys its freelance_profile' do
        expect(FreelancerProfile.exists?(freelancer_profile.id)).to be_truthy
        user.destroy
        expect(FreelancerProfile.exists?(freelancer_profile.id)).to be_falsey
      end

      it { should belong_to(:signup_promo).optional }
    end

    describe 'jobs' do
      let!(:job) { FactoryBot.create(:job, user: user) }
      it 'has many' do
        expect(user.jobs).to include(job)
      end

      it 'dependent destroy' do
        user.destroy
        expect(Job.exists?(job.id)).to be_falsey
      end
    end

    describe 'freelancer_sectors and freelancer_real_estate_skills' do
      let!(:freelancer_sector) { FactoryBot.create(:freelancer_sector, freelancer_profile: freelancer_profile) }
      let!(:freelancer_real_estate_skill) { FactoryBot.create(:freelancer_real_estate_skill, freelancer_profile: freelancer_profile) }

      it 'can have many through the freelance_profile' do
        expect(user.freelancer_sectors).to include(freelancer_sector)
        expect(user.freelancer_real_estate_skills).to include(freelancer_real_estate_skill)
      end
    end
  end

  context 'Scopes' do
    let!(:confirmed) { FactoryBot.create(:user, confirmed_at: 3.days.ago) }
    let!(:not_confirmed) { FactoryBot.create(:user, confirmed_at: nil) }
    let(:freelancer_user) { FactoryBot.create(:freelancer_profile).user }
    let(:employer_user) { FactoryBot.create(:employer_profile).user }

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
end
