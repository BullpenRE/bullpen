require 'rails_helper'

RSpec.describe Contract, type: :model do
  let(:employer_profile) { FactoryBot.create(:employer_profile) }
  let(:freelancer_profile) { FactoryBot.create(:freelancer_profile) }
  let!(:contract) { FactoryBot.create(:contract, employer_profile: employer_profile, freelancer_profile: freelancer_profile, pay_rate: 100) }
  let(:job) { FactoryBot.create(:job, employer_profile: employer_profile) }
  let(:contract_with_job) { FactoryBot.create(:contract, :with_job, job: job) }

  it 'factories work' do
    expect(contract).to be_valid
    expect(contract_with_job).to be_valid
    expect(contract.reload.payment_account).to be_present
  end

  context 'Validations' do
    it 'the from and to user cannot be the same person' do
      contract.employer_profile.user_id = contract.freelancer_profile.user_id
      expect(contract).to_not be_valid
    end

    it 'the payment_account must belong to the employer' do
      different_employer = FactoryBot.create(:employer_profile)
      contract.employer_profile_id = different_employer.id
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

    it 'can belong to a payment_contract' do
      expect(contract.payment_account).to be_present
    end

    describe 'job' do
      it 'belongs to' do
        expect(contract_with_job.job).to eq(job)
      end

      describe 'when created via a job it inherits' do
        let(:new_contract) { job.contracts.create(employer_profile: employer_profile, freelancer_profile: freelancer_profile, title: '', job_description: '') }
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

    it 'has many billings, dependent nullify' do
      billing = FactoryBot.create(:billing, contract: contract)
      expect(contract.billings).to include(billing)
      contract.destroy
      expect(Billing.exists?(billing.id)).to be_falsey
    end
  end

  context 'Scopes' do
    let!(:pending_contract) { FactoryBot.create(:contract, state: 'pending') }
    let!(:declined_contract) { FactoryBot.create(:contract, state: 'declined') }
    let!(:withdrawn_contract) { FactoryBot.create(:contract, state: 'withdrawn') }
    let!(:accepted_contract) { FactoryBot.create(:contract, state: 'accepted') }
    let!(:closed_contract) { FactoryBot.create(:contract, state: 'closed') }
    let!(:removed_contract_from_freelancer) { FactoryBot.create(:contract, hide_from_freelancer: true) }
    let!(:removed_contract_from_employer) { FactoryBot.create(:contract, hide_from_employer: true) }

    it '.pending, .declined, .withdrawn, .accepted, .closed' do
      expect(Contract.pending).to include(pending_contract)
      expect(Contract.declined).to include(declined_contract)
      expect(Contract.withdrawn).to include(withdrawn_contract)
      expect(Contract.accepted).to include(accepted_contract)
    end

    it '.hire_group' do
      expect(Contract.hire_group).to include(pending_contract)
      expect(Contract.hire_group).to include(accepted_contract)
      expect(Contract.hire_group).to include(closed_contract)
      expect(Contract.hire_group).to_not include(declined_contract)
      expect(Contract.hire_group).to_not include(withdrawn_contract)
    end

    it '.offers' do
      expect(Contract.offers).to include(pending_contract)
      expect(Contract.offers).to_not include(declined_contract)
      expect(Contract.offers).to_not include(withdrawn_contract)
      expect(Contract.offers).to_not include(accepted_contract)
    end

    it '.active' do
      expect(Contract.active).to_not include(pending_contract)
      expect(Contract.active).to_not include(declined_contract)
      expect(Contract.active).to_not include(withdrawn_contract)
      expect(Contract.active).to include(accepted_contract)
      expect(Contract.active).to include(closed_contract)
    end

    it '.freelancer_visible' do
      expect(Contract.freelancer_visible).to_not include(removed_contract_from_freelancer)
      expect(Contract.freelancer_visible).to include(pending_contract)
      expect(Contract.freelancer_visible).to include(declined_contract)
      expect(Contract.freelancer_visible).to include(withdrawn_contract)
      expect(Contract.freelancer_visible).to include(accepted_contract)
      expect(Contract.freelancer_visible).to include(closed_contract)
    end

    it '.employer_visible' do
      expect(Contract.employer_visible).to_not include(removed_contract_from_employer)
      expect(Contract.employer_visible).to include(pending_contract)
      expect(Contract.employer_visible).to include(declined_contract)
      expect(Contract.employer_visible).to include(withdrawn_contract)
      expect(Contract.employer_visible).to include(accepted_contract)
      expect(Contract.employer_visible).to include(closed_contract)
    end
  end

  context 'Methods' do
    it 'calculates payout_rate correctly' do
      expect(contract.payout_rate).to eq(70)
    end
  end

end
