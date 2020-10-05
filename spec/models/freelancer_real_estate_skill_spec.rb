require 'rails_helper'

RSpec.describe FreelancerRealEstateSkill, type: :model do
  let!(:freelancer_real_estate_skill) { FactoryBot.create(:freelancer_real_estate_skill) }

  it 'factory works' do
    expect(freelancer_real_estate_skill).to be_valid
  end
end
