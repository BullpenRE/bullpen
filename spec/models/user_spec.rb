require 'rails_helper'

describe User do
  let!(:user) { FactoryBot.create(:user) }

  it 'factory works' do
    expect(user).to be_valid
  end
end
