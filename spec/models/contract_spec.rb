require 'rails_helper'

RSpec.describe Contract, type: :model do
  let!(:contract) { FactoryBot.create(:contract) }
  let(:contract_with_job) { FactoryBot.create(:contract, :with_job) }

  it 'factories work' do
    expect(contract).to be_valid
    expect(contract_with_job).to be_valid
  end
end
