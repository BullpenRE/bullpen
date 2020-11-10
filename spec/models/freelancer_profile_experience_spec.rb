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

  context 'Methods' do
    it '#update_start_date' do
      freelancer_profile_experience.update(start_month: 2, start_year: 2015)
      expect(freelancer_profile_experience.start_date).to eq Date.strptime('2015-2', '%Y-%m')
    end

    it '#update_end_date' do
      freelancer_profile_experience.update(end_month: 2, end_year: 2020)
      expect(freelancer_profile_experience.end_date).to eq Date.strptime('2020-2', '%Y-%m')
    end

    it '#description_paragraphs' do
      freelancer_profile_experience.update(description: "Some point 1\n\nSome point 2\nSome point 3")
      expect(freelancer_profile_experience.description_paragraphs).to eq(['Some point 1', 'Some point 2', 'Some point 3'])
      freelancer_profile_experience.update(description: "A ")
      expect(freelancer_profile_experience.reload.description_paragraphs).to eq(['A '])
    end
  end
end
