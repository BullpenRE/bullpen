require 'rails_helper'

RSpec.describe SignupPromo, type: :model do
  let!(:signup_promo) { FactoryBot.create(:signup_promo) }

  it 'factory works' do
    expect(signup_promo).to be_valid
  end

  context 'Validations' do
    it 'promo_code valid' do
      new_promo_code = FactoryBot.create(:signup_promo)
      expect(new_promo_code).to be_valid
    end
  end

  context 'Relationships' do
    it { expect(signup_promo).to have_many(:users) }
  end
end
