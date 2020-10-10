require 'rails_helper'

RSpec.describe FreelancerProfileExperience, type: :model do
  let(:user)  { FactoryBot.create(:user) }
  let!(:freelancer_profile) { FactoryBot.create(:freelancer_profile, user: user) }
  let!(:freelancer_profile_experience) { create(:freelancer_profile_experience, freelancer_profile: freelancer_profile) }

  it 'factory works' do
    expect(freelancer_profile_experience).to be_valid
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:job_title) }
    it { is_expected.to validate_presence_of(:company) }
    it { is_expected.to validate_presence_of(:location) }
    it { is_expected.to validate_presence_of(:description) }
  end

  context 'Relationships' do
    it 'belongs_to a freelancer_profile' do
      expect(freelancer_profile_experience.freelancer_profile).to eq(freelancer_profile)
    end
  end
end
