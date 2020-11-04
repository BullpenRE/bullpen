require 'rails_helper'

RSpec.describe FreelancerSoftware, type: :model do
  let(:software) { FactoryBot.create(:software) }
  let(:freelancer_profile) { FactoryBot.create(:freelancer_profile) }
  let!(:freelancer_software) { FactoryBot.create(:freelancer_software, freelancer_profile: freelancer_profile, software: software) }

  it 'factory works' do
    expect(freelancer_software).to be_valid
  end

  context 'Validations' do
    it 'the combination of its freelancer_profile_id and software_id must be unique' do
      duplicate = FactoryBot.create(:freelancer_software)
      duplicate.freelancer_profile_id = freelancer_software.freelancer_profile_id
      expect(duplicate.valid?).to be_truthy
      duplicate.software_id = freelancer_software.software_id
      expect(duplicate.valid?).to be_falsey
    end
  end

  context 'Relationships' do
    it 'belongs_to a freelancer_profile' do
      expect(freelancer_software.freelancer_profile).to eq(freelancer_profile)
    end

    it 'belongs to a software' do
      expect(freelancer_software.software).to eq(software)
    end
  end

end
