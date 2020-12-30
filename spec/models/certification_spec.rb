require 'rails_helper'

RSpec.describe Certification, type: :model do
  let!(:certification) { FactoryBot.create(:certification) }
  let!(:custom_certification) { FactoryBot.create(:certification, :custom) }

  it 'factories work' do
    expect(certification).to be_valid
    expect(custom_certification).to be_valid
  end

  context 'Validations' do
    it 'description is unique' do
      duplicate = FactoryBot.create(:certification)
      expect(duplicate).to be_valid
      duplicate.description = certification.description
      expect(duplicate).to_not be_valid
    end

    it 'if custom is true description must be nil or blank' do
      expect(custom_certification.custom).to be_truthy
      expect(custom_certification.description).to be_nil
      custom_certification.description = 'something'
      expect(custom_certification).to_not be_valid
    end

    it 'if custom is false description must be present' do
      expect(certification.custom).to be_falsey
      expect(certification.description).to be_present
      certification.description = ''
      expect(certification).to_not be_valid
      certification.description = nil
      expect(certification).to_not be_valid
      certification.description = 'something'
      expect(certification).to be_valid
    end

    it 'description must be unique' do
      duplicate = FactoryBot.create(:certification)
      expect(duplicate).to be_valid
      duplicate.description = certification.description
      expect(duplicate).to_not be_valid
    end

    it 'there can only be one custom entry' do
      duplicate = FactoryBot.build(:certification, :custom)
      expect(duplicate).to_not be_valid
      duplicate.description = 'XOXOXOX'
      expect(duplicate).to_not be_valid
      duplicate.custom = false
      expect(duplicate).to be_valid
    end
  end

  context 'Relationships' do
    let!(:freelancer_profile) { FactoryBot.create(:freelancer_profile) }
    let!(:freelancer_certification) { FactoryBot.create(:freelancer_certification, freelancer_profile: freelancer_profile, certification: certification) }

    it 'has many freelancer_certifications with dependent destroy' do
      expect(certification.freelancer_certifications).to include(freelancer_certification)
      certification.destroy
      expect(FreelancerCertification.exists?(freelancer_certification.id)).to be_falsey
    end

    it 'has many freelancer_profiles through freelancer_certifications' do
      expect(certification.freelancer_profiles).to include(freelancer_profile)
    end
  end

  context 'Scopes' do
    it '.searchable' do
      expect(Certification.searchable).to include(certification)
      expect(Certification.searchable).to_not include(custom_certification)
    end
  end

  it '.enabled' do
    disabled_certification = FactoryBot.create(:certification, disable: true)
    expect(certification.disable).to be_falsey
    expect(Certification.enabled).to include(certification)
    expect(Certification.enabled).to_not include(disabled_certification)
  end

  context 'Methods' do
    it 'self.custom_id' do
      expect(Certification.custom_id).to eq(custom_certification.id)
      custom_certification.destroy
      expect(Certification.custom_id).to be_nil
    end
  end
end
