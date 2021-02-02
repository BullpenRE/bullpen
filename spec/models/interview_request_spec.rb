require 'rails_helper'

RSpec.describe InterviewRequest, type: :model do
  let(:employer_user) { FactoryBot.create(:user, :employer) }
  let(:employer_profile) { FactoryBot.create(:employer_profile, user: employer_user) }
  let(:freelancer_user)  { FactoryBot.create(:user, :freelancer) }
  let(:freelancer_profile) { FactoryBot.create(:freelancer_profile, user: freelancer_user) }
  let!(:interview_request) { FactoryBot.create(:interview_request, employer_profile: employer_profile, freelancer_profile: freelancer_profile) }

  it 'factory works' do
    expect(interview_request).to be_valid
    expect(interview_request.message).to be_present
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

  context 'Scopes' do
    let(:freelancer_user_dima)  { FactoryBot.create(:user, :freelancer) }
    let(:freelancer_profile_dima) { FactoryBot.create(:freelancer_profile, user: freelancer_user_dima) }
    let(:freelancer_user_nata)  { FactoryBot.create(:user, :freelancer) }
    let(:freelancer_profile_nata) { FactoryBot.create(:freelancer_profile, user: freelancer_user_nata) }
    let(:freelancer_user_erik)  { FactoryBot.create(:user, :freelancer) }
    let(:freelancer_profile_erik) { FactoryBot.create(:freelancer_profile, user: freelancer_user_erik) }
    let(:freelancer_user_ben)  { FactoryBot.create(:user, :freelancer) }
    let(:freelancer_profile_ben) { FactoryBot.create(:freelancer_profile, user: freelancer_user_ben) }
    let(:freelancer_user_ron)  { FactoryBot.create(:user, :freelancer) }
    let(:freelancer_profile_ron) { FactoryBot.create(:freelancer_profile, user: freelancer_user_ron) }
    let!(:interview_request_pending) { FactoryBot.create(:interview_request, employer_profile: employer_profile, freelancer_profile: freelancer_profile_nata, state: 'pending') }
    let!(:interview_request_accepted) { FactoryBot.create(:interview_request, employer_profile: employer_profile, freelancer_profile: freelancer_profile_dima, state: 'accepted') }
    let!(:interview_request_declined) { FactoryBot.create(:interview_request, employer_profile: employer_profile, freelancer_profile: freelancer_profile_erik, state: 'declined') }
    let!(:removed_interview_request_from_freelancer) { FactoryBot.create(:interview_request, employer_profile: employer_profile, freelancer_profile: freelancer_profile_ben, hide_from_freelancer: true) }
    let!(:removed_interview_request_from_employer) { FactoryBot.create(:interview_request, employer_profile: employer_profile, freelancer_profile: freelancer_profile_ron, hide_from_employer: true) }

    it '.not_rejected' do
      expect(InterviewRequest.not_rejected).to include(interview_request_pending)
      expect(InterviewRequest.not_rejected).to include(interview_request_accepted)
      expect(InterviewRequest.not_rejected).to_not include(interview_request_declined)
    end

    it '.freelancer_visible' do
      expect(InterviewRequest.freelancer_visible).to_not include(removed_interview_request_from_freelancer)
      expect(InterviewRequest.freelancer_visible).to include(interview_request_pending)
      expect(InterviewRequest.freelancer_visible).to include(interview_request_accepted)
      expect(InterviewRequest.freelancer_visible).to include(interview_request_declined)
      expect(InterviewRequest.freelancer_visible).to include(removed_interview_request_from_employer)
    end

    it '.employer_visible' do
      expect(InterviewRequest.employer_visible).to_not include(removed_interview_request_from_employer)
      expect(InterviewRequest.employer_visible).to include(interview_request_pending)
      expect(InterviewRequest.employer_visible).to include(interview_request_accepted)
      expect(InterviewRequest.employer_visible).to include(interview_request_declined)
      expect(InterviewRequest.employer_visible).to include(removed_interview_request_from_freelancer)
    end
  end
end
