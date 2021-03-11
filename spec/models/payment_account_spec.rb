require 'rails_helper'

RSpec.describe PaymentAccount, type: :model do
  let!(:card_payment_account) { FactoryBot.create(:payment_account, card_brand: 'American Express', last_four: '1234') }
  let!(:bank_payment_account) { FactoryBot.create(:payment_account, :bank, last_four: '4321') }

  it 'factories work' do
    expect(card_payment_account).to be_valid
    expect(bank_payment_account).to be_valid
  end

  describe 'Relationships' do
    let!(:contract) { FactoryBot.create(:contract, employer_profile: card_payment_account.employer_profile, payment_account: card_payment_account) }
    it 'has_many contracts, dependent: :nullify' do
      expect(card_payment_account.contracts).to include(contract)
      card_payment_account.destroy
      expect(contract.reload.payment_account).to be_nil
    end
  end

  describe 'Validations' do
    context 'last_four' do
      it 'must be 4 digits' do
        card_payment_account.last_four = '4233453223'
        expect(card_payment_account).to_not be_valid
      end
      it 'can be blank or nil' do
        card_payment_account.last_four = ''
        expect(card_payment_account).to be_valid
        card_payment_account.last_four = nil
        expect(card_payment_account).to be_valid
      end
    end
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

  describe 'Methods' do
    it '#institution' do
      expect(card_payment_account.institution).to eq(card_payment_account.card_brand)
      expect(bank_payment_account.institution).to eq(bank_payment_account.bank_name)
    end

    it '#status' do
      expect(card_payment_account.status).to eq(card_payment_account.card_cvc_check)
      expect(bank_payment_account.status).to eq(bank_payment_account.bank_status)
    end

    it '#expired?' do
      card_payment_account.update(card_expires: 2.months.from_now)
      expect(card_payment_account.expired?).to be_falsey
      card_payment_account.update(card_expires: 2.months.ago)
      expect(card_payment_account.expired?).to be_truthy
      card_payment_account.update(card_expires: nil)
      expect(card_payment_account.expired?).to be_falsey
    end

    it '#short_description' do
      expect(card_payment_account.short_description).to eq('American Express card ending in 1234 (default)')
      expect(bank_payment_account.short_description).to eq('Bank account ending in 4321 (default)')

      visa_account = FactoryBot.create(:payment_account, card_brand: 'Visa', last_four: '3333', employer_profile: card_payment_account.employer_profile)

      expect(card_payment_account.reload.short_description).to eq('American Express card ending in 1234')
      expect(visa_account.short_description).to eq('Visa card ending in 3333 (default)')
    end
  end
end
