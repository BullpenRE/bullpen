require 'rails_helper'

RSpec.describe PaymentAccount, type: :model do
  let!(:card_payment_account) { FactoryBot.create(:payment_account) }
  let!(:bank_payment_account) { FactoryBot.create(:payment_account, :bank) }

  it 'factories work' do
    expect(card_payment_account).to be_valid
    expect(bank_payment_account).to be_valid
  end

  describe 'Actions' do
    let!(:employer_profile) { FactoryBot.create(:employer_profile) }
    let!(:first_account) { FactoryBot.create(:payment_account, employer_profile: employer_profile, default: true) }

    context 'When creating a new payment_account' do
      it 'if default set to true, the others that belong to the same employer_profile are set to false' do
        expect(first_account.default?).to be_truthy
        FactoryBot.create(:payment_account, employer_profile: employer_profile, default: true)
        expect(first_account.reload.default?).to be_falsey
      end

      it 'if default is set to false, the others are not changed' do
        FactoryBot.create(:payment_account, employer_profile: employer_profile, default: false)
        expect(first_account.default?).to be_truthy
      end

      it 'does not impact other employer defaults' do
        FactoryBot.create(:payment_account, employer_profile: employer_profile, default: true)
        expect(card_payment_account.default?).to be_truthy
        expect(bank_payment_account.default?).to be_truthy
      end
    end

    context 'When updating existing payment_accounts' do
      let!(:second_account) { FactoryBot.create(:payment_account, employer_profile: employer_profile, default: true) }

      it 'factories are set up properly' do
        expect(first_account.reload.default?).to be_falsey
        expect(second_account.default?).to be_truthy
      end

      it 'when one of the existing accounts is set to default' do
        first_account.update(default: true)
        expect(second_account.reload.default?).to be_falsey
      end
    end
  end
end
