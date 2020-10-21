require 'rails_helper'

RSpec.describe FreelancerProfile, type: :model do
  let(:user)  { FactoryBot.create(:user) }
  let!(:freelancer_profile) { FactoryBot.create(:freelancer_profile, user: user) }
  let(:avatar_image) { File.open(Rails.root.join('spec', 'support', 'assets', 'sample-avatar.jpg')) }
  let(:big_avatar_image) { File.open(Rails.root.join('spec', 'support', 'assets', 'big_avatar.jpg')) }
  let(:wrong_type_avatar) { File.open(Rails.root.join('spec', 'support', 'assets', 'wrong_type_avatar.numbers')) }

  it 'factory works' do
    expect(freelancer_profile).to be_valid
  end

  context 'Validations'

  context 'Relationships' do
    it 'belongs_to a user' do
      expect(freelancer_profile.user).to eq(user)
    end

    context 'freelancer_asset_classes and freelancer_real_estate_skills' do
      let!(:freelancer_asset_class) { FactoryBot.create(:freelancer_asset_class, freelancer_profile: freelancer_profile) }
      let!(:freelancer_real_estate_skill) { FactoryBot.create(:freelancer_real_estate_skill, freelancer_profile: freelancer_profile) }

      it 'can have many freelancer_asset_classes' do
        expect(freelancer_profile.freelancer_asset_classes).to include(freelancer_asset_class)
      end

      it 'can have many freelance_real_estate_skills' do
        expect(freelancer_profile.freelancer_real_estate_skills).to include(freelancer_real_estate_skill)
      end

      it 'getting destroyed destroys both freelancer_asset_classes and freelance_real_estate_skills' do
        expect(FreelancerAssetClass.exists?(freelancer_asset_class.id)).to be_truthy
        expect(FreelancerRealEstateSkill.exists?(freelancer_real_estate_skill.id)).to be_truthy

        freelancer_profile.destroy

        expect(FreelancerAssetClass.exists?(freelancer_asset_class.id)).to be_falsey
        expect(FreelancerRealEstateSkill.exists?(freelancer_real_estate_skill.id)).to be_falsey
      end

      it 'can have asset_classes through freelancer_asset_classes' do
        expect(freelancer_profile.asset_classes).to include(freelancer_asset_class.asset_class)
      end

      it 'can have real_estate_skills through freelancer_real_estate_skills' do
        expect(freelancer_profile.real_estate_skills).to include(freelancer_real_estate_skill.real_estate_skill)
      end

    end
  end

  context 'Methods' do
    describe '#correct_size?' do
      it 'without attached avatar' do
        expect(freelancer_profile).to be_valid
      end
      it 'with right size avatar' do
        freelancer_profile.avatar.attach(io: avatar_image, filename: File.basename(avatar_image.path), content_type: 'image/jpg')
        expect(freelancer_profile).to be_valid
      end
      it 'with big size avatar' do
        freelancer_profile.avatar.attach(io: big_avatar_image, filename: File.basename(big_avatar_image.path), content_type: 'image/jpg')
        expect(freelancer_profile).to_not be_valid
        expect(freelancer_profile.errors.messages[:base]).to eq ['Uploaded files must not exceed 2MB.']
      end
    end
    describe 'correct_content_type?' do
      it 'without attached avatar' do
        expect(freelancer_profile).to be_valid
      end
      it 'with valid type avatar' do
        freelancer_profile.avatar.attach(io: avatar_image, filename: File.basename(avatar_image.path), content_type: 'image/jpg')
        expect(freelancer_profile).to be_valid
      end
      it 'with invalid type avatar' do
        freelancer_profile.avatar.attach(io: wrong_type_avatar, filename: File.basename(wrong_type_avatar.path), content_type: 'image/jpg')
        expect(freelancer_profile).to_not be_valid
        expect(freelancer_profile.errors.messages[:base]).to eq ['Please upload only a jpg, png or gif image.']
      end
    end
  end
end
