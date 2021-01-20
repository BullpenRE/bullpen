require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:from_user) { FactoryBot.create(:user) }
  let(:to_user) { FactoryBot.create(:user) }
  let!(:message) { FactoryBot.create(:message, from_user: from_user, to_user: to_user) }

  it 'factory works' do
    expect(message).to be_valid
    expect(message.description.present?).to be_truthy
  end

  context 'Validations' do
    it 'the from and to user cannot be the same person' do
      message.to_user_id = message.from_user_id
      expect(message).to_not be_valid
    end
  end

  context 'Relationships' do
    it 'belongs to a from_user' do
      expect(message.from_user).to eq(from_user)
    end

    it 'belongs to a to_user' do
      expect(message.to_user).to eq(to_user)
    end
  end
end
