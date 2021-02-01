require 'rails_helper'

RSpec.describe FreelancerRealEstateSkill, type: :model do
  let(:freelancer_profile) { FactoryBot.create(:freelancer_profile) }
  let(:real_estate_skill) { FactoryBot.create(:real_estate_skill) }
  let!(:freelancer_real_estate_skill) { FactoryBot.create(:freelancer_real_estate_skill, freelancer_profile: freelancer_profile, real_estate_skill: real_estate_skill) }

  it 'factory works' do
    expect(freelancer_real_estate_skill).to be_valid
  end

  context 'Validations' do
    it 'the combination of freelancer_profile_id and real_estate_skill_id must be unique' do
      duplicate = FactoryBot.create(:freelancer_real_estate_skill)
      duplicate.freelancer_profile_id = freelancer_real_estate_skill.freelancer_profile_id
      expect(duplicate.valid?).to be_truthy
      duplicate.real_estate_skill_id = freelancer_real_estate_skill.real_estate_skill_id
      expect(duplicate.valid?).to be_falsey
    end
  end

  context 'Relationships' do
    it 'belongs_to a freelancer_profile' do
      expect(freelancer_real_estate_skill.freelancer_profile).to eq(freelancer_profile)
    end

    it 'belongs_to a real_estate_skill' do
      expect(freelancer_real_estate_skill.real_estate_skill).to eq(real_estate_skill)
    end
  end
end
