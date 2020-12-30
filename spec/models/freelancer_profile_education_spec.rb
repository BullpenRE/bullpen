require 'rails_helper'

RSpec.describe FreelancerProfileEducation, type: :model do
  let(:user) { FactoryBot.create(:user, :freelancer) }
  let!(:freelancer_profile) { FactoryBot.create(:freelancer_profile, user: user) }
  let!(:freelancer_profile_education) { FactoryBot.create(:freelancer_profile_education, freelancer_profile: freelancer_profile) }
  let(:freelancer_profile_education_current) { FactoryBot.create(:freelancer_profile_education, :current, freelancer_profile: freelancer_profile) }

  it 'factory works' do
    expect(freelancer_profile_education).to be_valid
    expect(freelancer_profile_education_current).to be_valid
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:institution) }
    it { is_expected.to validate_presence_of(:course_of_study) }
    it { is_expected.to validate_presence_of(:degree) }
  end

  context 'Relationships' do
    it 'belongs_to a freelancer_profile' do
      expect(freelancer_profile_education.freelancer_profile).to eq(freelancer_profile)
    end

    it 'has a user through the freelancer_profile' do
      expect(freelancer_profile_education.user).to eq(freelancer_profile.user)
    end
  end
end
