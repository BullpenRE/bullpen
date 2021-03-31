require 'rails_helper'

RSpec.describe Billing, type: :model do
  let(:contract) { FactoryBot.create(:contract) }
  let!(:billing) { FactoryBot.create(:billing, contract: contract) }
  let!(:disputed_billing) { FactoryBot.create(:billing, :disputed) }
  let!(:resolved_billing) { FactoryBot.create(:billing, :resolved) }
  let!(:paid_billing) { FactoryBot.create(:billing, :paid) }
  let!(:billing_with_timesheet) { FactoryBot.create(:billing, :with_timesheet) }
  let(:timesheet) { billing_with_timesheet.timesheet }

  it 'factories work' do
    expect(billing).to be_valid
    expect(disputed_billing).to be_valid
    expect(resolved_billing).to be_valid
    expect(paid_billing).to be_valid
    expect(billing_with_timesheet).to be_valid
  end

  context 'Validations' do
    it 'hours must be a positive number, nil or zero' do
      billing.minutes = 1
      billing.hours = -1
      expect(billing).to_not be_valid
      billing.hours = 0
      expect(billing).to be_valid
      billing.hours = nil
      expect(billing).to be_valid
    end

    it 'minutes must be nil or between 0 - 59' do
      billing.hours = 1
      billing.minutes = nil
      expect(billing).to be_valid
      billing.minutes = 0
      expect(billing).to be_valid
      billing.minutes = 59
      expect(billing).to be_valid
      billing.minutes = 60
      expect(billing).to_not be_valid
    end

    it 'both minutes and hours cannot be blank' do
      billing.hours = nil
      billing.minutes = nil
      expect(billing).to_not be_valid
      billing.hours = 0
      billing.minutes = 0
      expect(billing).to_not be_valid
    end

    it 'parent timesheet must belong to the same contract as the billing' do
      expect(billing_with_timesheet.contract).to eq(timesheet.contract)
      billing_with_timesheet.contract_id = FactoryBot.create(:contract).id
      expect(billing_with_timesheet).to_not be_valid
    end
  end

  context 'Relationships' do
    it 'belongs to a contract' do
      expect(billing.contract).to eq(contract)
    end

    it 'belongs to a timesheet' do
      expect(Timesheet.exists?(timesheet.id)).to be_truthy
    end
  end

  context 'Scopes' do
    it '.pending, .disputed, .paid, .resolved' do
      expect(Billing.pending).to include(billing)
      expect(Billing.disputed).to include(disputed_billing)
      expect(Billing.paid).to include(paid_billing)
      expect(Billing.resolved).to include(resolved_billing)
    end

    it '.current' do
      expect(Billing.current).to include(billing)
      expect(Billing.current).to_not include(disputed_billing)
    end

     it '.paused' do
       expect(Billing.paused).to include(disputed_billing)
       expect(Billing.paused).to_not include(billing)
    end
  end

  context 'Methods' do
    it '#multiplier' do
      billing.update(hours: 2, minutes: 45)
      expect(billing.multiplier).to eq(2.75)
      billing.update(hours: nil, minutes: 45)
      expect(billing.multiplier).to eq(0.75)
    end

    describe '#find_or_create_timesheet' do
      let(:unattached_billing) { FactoryBot.create(:billing, work_done: 10.days.ago, contract: contract) }
      let!(:unrelated_contract_timesheet) { FactoryBot.create(:timesheet, starts: 20.days.ago, ends: 2.days.ago) }

      describe 'if a qualifying timesheet exists' do
        let!(:related_contract_but_old_timesheet) { FactoryBot.create(:timesheet, contract: contract, starts: 30.days.ago, ends: 20.days.ago) }
        let!(:related_contract_current_timesheet) { FactoryBot.create(:timesheet, contract: contract, starts: 20.days.ago, ends: 2.days.ago) }

        it 'attaches' do
          expect(unattached_billing.timesheet).to eq(related_contract_current_timesheet)
        end
      end

      describe 'if no qualifying timesheet exists' do
        it 'creates and attaches a timesheet that starts on sunday and ends on saturday' do
          expect(unattached_billing.timesheet).to be_present
          expect(unattached_billing.timesheet.starts.monday?).to be_truthy
          expect(unattached_billing.timesheet.ends.sunday?).to be_truthy
        end
      end
    end
  end
end
