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

    it 'can have one freelance_profile' do
      expect(user.freelancer_profile).to eq(freelancer_profile)
    end
  end
end
