require 'rails_helper'

RSpec.describe RealEstateSkill, type: :model do
  let!(:real_estate_skill) { FactoryBot.create(:real_estate_skill) }
  it 'factory works' do
    expect(real_estate_skill).to be_valid
  end

  context 'Validations' do
    it 'description is unique' do
      new_real_estate_skill = FactoryBot.create(:real_estate_skill)
      expect(new_real_estate_skill).to be_valid
      new_real_estate_skill.description = real_estate_skill.description
      expect(new_real_estate_skill).to_not be_valid
    end
  end

  context 'Relationships' do
    let!(:freelancer_real_estate_skill) { FactoryBot.create(:freelancer_real_estate_skill, real_estate_skill: real_estate_skill) }
    it 'has many freelancer_real_estate_skills' do
      expect(real_estate_skill.freelancer_real_estate_skills).to include(freelancer_real_estate_skill)
    end
  end

end
