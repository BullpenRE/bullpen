require 'rails_helper'

RSpec.describe EmployerProfile, type: :model do
  let(:user)  { FactoryBot.create(:user) }
  let!(:employer_profile) { FactoryBot.create(:employer_profile, user: user) }

  it 'factory works' do
    expect(employer_profile).to be_valid
  end

  context 'Validations' do
    it { should belong_to(:user) }
  end

  context 'Relationships' do
    it 'belongs_to a user' do
      expect(employer_profile.user).to eq(user)
    end
  end

  context 'Methods'
end
