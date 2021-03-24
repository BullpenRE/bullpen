require 'rails_helper'

RSpec.describe Billing, type: :model do
  let(:contract) { FactoryBot.create(:contract) }
  let!(:billing) { FactoryBot.create(:billing, contract: contract) }
  let!(:disputed_billing) { FactoryBot.create(:billing, :disputed) }
  let!(:resolved_billing) { FactoryBot.create(:billing, :resolved) }
  let!(:paid_billing) { FactoryBot.create(:billing, :paid) }

  it 'factories work' do
    expect(billing).to be_valid
    expect(disputed_billing).to be_valid
    expect(resolved_billing).to be_valid
    expect(paid_billing).to be_valid
  end

  context 'Validations' do
    it 'hours must be a positive number, nil or zero' do
      billing.hours = -1
      expect(billing).to_not be_valid
      billing.hours = 0
      expect(billing).to be_valid
      billing.hours = nil
      expect(billing).to be_valid
    end

    it 'minutes must be nil or between 0 - 59' do
      billing.minutes = nil
      expect(billing).to be_valid
      billing.minutes = 0
      expect(billing).to be_valid
      billing.minutes = 59
      expect(billing).to be_valid
      billing.minutes = 60
      expect(billing).to_not be_valid
    end
  end

  context 'Relationships' do
    it 'belongs to a contract' do
      expect(billing.contract).to eq(contract)
    end
  end

  context 'Scopes' do
    it '.pending, .disputed, .paid, .resolved' do
      expect(Billing.pending).to include(billing)
      expect(Billing.disputed).to include(disputed_billing)
      expect(Billing.paid).to include(paid_billing)
      expect(Billing.resolved).to include(resolved_billing)
    end
  end

  context 'Methods' do
    it '#multiplier' do
      billing.update(hours: 2, minutes: 45)
      expect(billing.multiplier).to eq(2.75)
      billing.update(hours: nil, minutes: 45)
      expect(billing.multiplier).to eq(0.75)
    end
  end
end
