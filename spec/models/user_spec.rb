require 'rails_helper'

describe User do
  let!(:user) { FactoryBot.create(:user) }

  it 'factory works' do
    expect(user).to be_valid
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
  end
end
