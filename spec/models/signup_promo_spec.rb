require 'rails_helper'

RSpec.describe SignupPromo, type: :model do
  let!(:signup_promo) { FactoryBot.create(:signup_promo) }
  let(:employer_signup_promo) { FactoryBot.create(:signup_promo, :employer) }
  let(:freelancer_signup_promo) { FactoryBot.create(:signup_promo, :freelancer) }

  it 'factory works' do
    expect(signup_promo).to be_valid
    expect(employer_signup_promo).to be_valid
    expect(freelancer_signup_promo).to be_valid
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

  context 'Scopes' do
    let!(:expired_promo) { FactoryBot.create(:signup_promo, expires: 3.days.ago) }
    let!(:valid_promo) { FactoryBot.create(:signup_promo, expires: 3.days.from_now) }
    it '.stillvalid' do
      expect(SignupPromo.stillvalid).to include(valid_promo)
      expect(SignupPromo.stillvalid).to_not include(expired_promo)
    end
  end
end
