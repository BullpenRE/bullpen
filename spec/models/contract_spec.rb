require 'rails_helper'

RSpec.describe Contract, type: :model do
  let(:employer_profile) { FactoryBot.create(:employer_profile) }
  let(:freelancer_profile) { FactoryBot.create(:freelancer_profile) }
  let!(:contract) { FactoryBot.create(:contract, employer_profile: employer_profile, freelancer_profile: freelancer_profile) }
  let(:job) { FactoryBot.create(:job, user: employer_profile.user) }
  let(:contract_with_job) { FactoryBot.create(:contract, :with_job, job: job) }

  it 'factories work' do
    expect(contract).to be_valid
    expect(contract_with_job).to be_valid
  end

  context 'Validations' do
    it 'the from and to user cannot be the same person' do
      contract.employer_profile.user_id = contract.freelancer_profile.user_id
      expect(contract).to_not be_valid
    end
  end

  context 'Relationships' do
    it 'belongs to a employer_profile' do
      expect(contract.employer_profile).to eq(employer_profile)
    end

    it 'belongs to a freelancer_profile' do
      expect(contract.freelancer_profile).to eq(freelancer_profile)
    end

    describe 'job' do
      it 'belongs to' do
        expect(contract_with_job.job).to eq(job)
      end

      describe 'when created via a job it inherits' do
        let(:new_contract) { job.contracts.create(employer_profile: employer_profile, freelancer_profile: freelancer_profile) }
        let(:new_contract_with_title) { job.contracts.create(employer_profile: employer_profile, freelancer_profile: freelancer_profile, title: 'Cool Job!') }

        it 'job_title, short_description, contract_type if blank' do
          expect(new_contract.title).to eq(job.title)
          expect(new_contract.job_description.body.to_plain_text).to eq(job.short_description)
          expect(new_contract.contract_type).to eq(job.contract_type)
        end

        it 'does not inherit if not blank' do
          expect(new_contract_with_title.title).to eq('Cool Job!')
          expect(new_contract_with_title.job_description.body.to_plain_text).to eq(job.short_description)
          expect(new_contract_with_title.contract_type).to eq(job.contract_type)
        end
      end
    end
  end

  context 'Scopes' do
    let!(:pending_contract) { FactoryBot.create(:contract, state: 'pending') }
    let!(:declined_contract) { FactoryBot.create(:contract, state: 'declined') }
    let!(:withdrawn_contract) { FactoryBot.create(:contract, state: 'withdrawn') }
    let!(:active_contract) { FactoryBot.create(:contract, state: 'active') }
    let!(:closed_contract) { FactoryBot.create(:contract, state: 'closed') }

    it '.pending, .declined, .withdrawn, .active, .closed' do
      expect(Contract.pending).to include(pending_contract)
      expect(Contract.declined).to include(declined_contract)
      expect(Contract.withdrawn).to include(withdrawn_contract)
      expect(Contract.active).to include(active_contract)
      expect(Contract.closed).to include(closed_contract)
    end

    it '.visible' do
      expect(Contract.visible).to include(pending_contract, active_contract, closed_contract)
      expect(Contract.visible).to_not include(declined_contract, withdrawn_contract)
    end
  end
end
