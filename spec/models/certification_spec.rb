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
end
