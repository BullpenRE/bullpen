require 'rails_helper'

RSpec.describe InterviewRequest, type: :model do
  let(:user)  { FactoryBot.create(:user) }
  let!(:employer_profile) { FactoryBot.create(:employer_profile, user: user) }
  let(:user1)  { FactoryBot.create(:user) }
  let!(:freelancer_profile) { FactoryBot.create(:freelancer_profile, user: user1) }
  let!(:interview_request) { FactoryBot.create(:interview_request, employer_profile: employer_profile, freelancer_profile: freelancer_profile) }

  it 'factory works' do
    expect(interview_request).to be_valid
  end

  context 'Validations'do
    it { is_expected.to validate_uniqueness_of(:employer_profile_id).scoped_to(:freelancer_profile_id) }

    it 'the combination of employer_profile_id and freelancer_id within interview_requests must be unique' do
      duplicate = FactoryBot.create(:interview_request)
      duplicate.employer_profile_id = interview_request.employer_profile_id
      expect(duplicate.valid?).to be_truthy
      duplicate.freelancer_profile_id = interview_request.freelancer_profile_id
      expect(duplicate.valid?).to be_falsey
    end
  end

  context 'Relationships' do
    it 'belongs_to a employer_profile' do
      expect(interview_request.employer_profile).to eq(employer_profile)
    end

    it 'belongs_to a freelancer_profile' do
      expect(interview_request.freelancer_profile).to eq(freelancer_profile)
    end

  end


end
