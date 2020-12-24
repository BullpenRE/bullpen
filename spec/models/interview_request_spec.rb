require 'rails_helper'

RSpec.describe InterviewRequest, type: :model do
  let(:employer_user)  { FactoryBot.create(:user) }
  let(:employer_profile) { FactoryBot.create(:employer_profile, user: employer_user) }
  let(:freelancer_user)  { FactoryBot.create(:user) }
  let(:freelancer_profile) { FactoryBot.create(:freelancer_profile, user: freelancer_user) }
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

  context 'Methods' do
    it '#message_paragraphs' do
      interview_request.update(message: "Dear Madam!\n\nNice to e-meet you.\nYour resume looks awesome.")
      expect( interview_request.message_paragraphs).to eq(['Dear Madam!', 'Nice to e-meet you.', 'Your resume looks awesome.'])
      interview_request.update(message: "A ")
      expect( interview_request.reload.message_paragraphs).to eq(['A '])
    end
  end
end
