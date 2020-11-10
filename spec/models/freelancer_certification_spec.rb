require 'rails_helper'

RSpec.describe FreelancerCertification, type: :model do
  let(:freelancer_profile) { FactoryBot.create(:freelancer_profile) }

  let(:certification) { FactoryBot.create(:certification) }
  let!(:freelancer_certification) { FactoryBot.create(:freelancer_certification, freelancer_profile: freelancer_profile, certification: certification) }

  let(:custom_certification) { FactoryBot.create(:certification, :custom) }
  let!(:freelancer_custom_certification) { FactoryBot.create(:freelancer_certification, freelancer_profile: freelancer_profile, certification: custom_certification) }

  it 'factories work' do
    expect(freelancer_certification).to be_valid
    expect(freelancer_custom_certification).to be_valid
  end

  context 'Validations' do
    it 'combination of freelancer_profile_id and description must be unique' do
      duplicate = FactoryBot.create(:freelancer_certification)
      expect(duplicate).to be_valid
      duplicate.freelancer_profile_id = freelancer_certification.freelancer_profile_id
      expect(duplicate).to be_valid
      duplicate.description = freelancer_certification.description
      expect(duplicate).to_not be_valid
    end

    it 'description must be present' do
      freelancer_certification.description = ''
      expect(freelancer_certification).to_not be_valid
      freelancer_certification.description = nil
      expect(freelancer_certification).to_not be_valid
      freelancer_certification.description = 'Hello world'
      expect(freelancer_certification).to be_valid
    end
  end

  context 'Relationships' do
    it 'belongs to freelancer_profile' do
      expect(freelancer_certification.freelancer_profile).to eq(freelancer_profile)
    end

    it 'has a user through the freelancer_profile' do
      expect(freelancer_certification.user).to eq(freelancer_profile.user)
    end

    it 'has a certificate' do
      expect(freelancer_certification.certification).to eq(certification)
    end
  end
end
