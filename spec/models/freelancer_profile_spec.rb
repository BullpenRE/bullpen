require 'rails_helper'

RSpec.describe FreelancerProfile, type: :model do
  let!(:freelancer_profile) { FactoryBot.create(:freelancer_profile) }

  it 'factory works' do
    expect(freelancer_profile).to be_valid
  end
end
