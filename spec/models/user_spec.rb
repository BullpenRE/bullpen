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
    end

    describe 'freelancer_asset_classes and freelancer_real_estate_skills' do
      let!(:freelancer_asset_class) { FactoryBot.create(:freelancer_asset_class, freelancer_profile: freelancer_profile) }
      let!(:freelancer_real_estate_skill) { FactoryBot.create(:freelancer_real_estate_skill, freelancer_profile: freelancer_profile) }

      it 'can have many through the freelance_profile' do
        expect(user.freelancer_asset_classes).to include(freelancer_asset_class)
        expect(user.freelancer_real_estate_skills).to include(freelancer_real_estate_skill)
      end
    end
  end

  context 'Scopes' do
    let!(:confirmed) { FactoryBot.create(:user, confirmed_at: 3.days.ago) }
    let!(:not_confirmed) { FactoryBot.create(:user, confirmed_at: nil) }

    it '.confirmed' do
      expect(User.confirmed).to include(confirmed)
      expect(User.confirmed).to_not include(not_confirmed)
    end
  end
end
