require 'rails_helper'

RSpec.describe EmployerProfile, type: :model do
  let(:user) { FactoryBot.create(:user, :employer) }
  let!(:employer_profile) { FactoryBot.create(:employer_profile, user: user) }
  let(:employer_profile_complete) { FactoryBot.create(:employer_profile, :complete) }
  let(:job) { FactoryBot.create(:job, employer_profile: employer_profile) }

  it 'factory works' do
    expect(employer_profile).to be_valid
    expect(employer_profile_complete).to be_valid
  end

  context 'Validations'

  context 'Relationships' do
    it 'belongs_to a user' do
      expect(employer_profile.user).to eq(user)
    end

    context 'employer_sectors' do
      let!(:employer_sector) { FactoryBot.create(:employer_sector, employer_profile: employer_profile) }

      it 'can have many employer_sectors' do
        expect(employer_profile.employer_sectors).to include(employer_sector)
      end

      it 'getting destroyed destroys employer_sectors' do
        expect(EmployerSector.exists?(employer_sector.id)).to be_truthy

        employer_profile.destroy

        expect(EmployerSector.exists?(employer_sector.id)).to be_falsey
      end

      it 'can have sectors through employer_sectors' do
        expect(employer_profile.sectors).to include(employer_sector.sector)
      end
    end

    context 'interview requests' do
      let(:employer_user)  { FactoryBot.create(:user) }
      let(:employer_profile) { FactoryBot.create(:employer_profile, user: employer_user) }
      let(:freelancer_user)  { FactoryBot.create(:user) }
      let!(:freelancer_profile) { FactoryBot.create(:freelancer_profile, user: freelancer_user) }
      let!(:interview_request) { FactoryBot.create(:interview_request, employer_profile: employer_profile, freelancer_profile: freelancer_profile) }

      it 'can have many interview_requests' do
        expect(employer_profile.interview_requests).to include(interview_request)
      end

      it 'getting destroyed destroys interview_requests' do
        expect { employer_profile.destroy }.to change { InterviewRequest.count }.by(-1)
      end
    end

    describe 'contracts' do
      let!(:contract) { FactoryBot.create(:contract, employer_profile: employer_profile) }

      it 'can have contracts, dependent destroy' do
        expect(employer_profile.contracts).to include(contract)
        employer_profile.destroy
        expect(Contract.exists?(contract.id)).to be_falsey
      end
    end

    describe 'reviews' do
      let!(:review) { FactoryBot.create(:review, employer_profile: employer_profile) }

      it 'can have reviews, dependent destroy' do
        expect(employer_profile.reviews).to include(review)
        employer_profile.destroy
        expect(Review.exists?(review.id)).to be_falsey
      end
    end

    it 'has many jobs dependent destroy' do
      expect(employer_profile.jobs).to include(job)
      employer_profile.destroy
      expect(Job.exists?(job.id)).to be_falsey
    end

    describe 'payment_accounts' do
      let!(:payment_account) { FactoryBot.create(:payment_account, employer_profile: employer_profile) }

      it 'has_many dependent: destroy' do
        expect(employer_profile.payment_accounts).to include(payment_account)
        employer_profile.destroy
        expect(PaymentAccount.exists?(payment_account.id)).to be_falsey
      end
    end
  end

  context 'Methods' do
    it '#completed?' do
      employer_profile.update(completed: true)
      expect(employer_profile.completed?).to be_truthy
      employer_profile.update(completed: false)
      expect(employer_profile.reload.completed?).to be_falsey
    end

    it '#email' do
      expect(employer_profile.email).to eq(user.email)
    end
  end
end
