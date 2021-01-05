require 'rails_helper'

RSpec.describe FreelancerProfile, type: :model do
  let(:user) { FactoryBot.create(:user, :freelancer) }
  let!(:freelancer_profile) { FactoryBot.create(:freelancer_profile, user: user) }
  let(:freelancer_profile_complete) { FactoryBot.create(:freelancer_profile, :complete) }
  let(:avatar_image) { File.open(Rails.root.join('spec', 'support', 'assets', 'sample-avatar.jpg')) }
  let(:big_avatar_image) { File.open(Rails.root.join('spec', 'support', 'assets', 'big_avatar.jpg')) }
  let(:wrong_type_avatar) { File.open(Rails.root.join('spec', 'support', 'assets', 'wrong_type_avatar.numbers')) }

  it 'factories work' do
    expect(freelancer_profile).to be_valid
    expect(freelancer_profile_complete).to be_valid
    expect(freelancer_profile_complete.real_estate_skills).to_not be_empty
    expect(freelancer_profile_complete.sectors).to_not be_empty
    expect(freelancer_profile_complete.softwares).to_not be_empty
    expect(freelancer_profile_complete.freelancer_profile_educations).to_not be_empty
    expect(freelancer_profile_complete.freelancer_profile_experiences).to_not be_empty
    expect(freelancer_profile_complete.freelancer_certifications).to_not be_empty
  end

  context 'Validations' do
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

    describe 'desired_hourly_rate' do
      it 'can be nil' do
        freelancer_profile.desired_hourly_rate = nil
        expect(freelancer_profile).to be_valid
      end

      it 'if not nil, then is a positive number' do
        freelancer_profile.desired_hourly_rate = -32
        expect(freelancer_profile).to_not be_valid
      end
    end
  end

  context 'Relationships' do
    it 'belongs_to a user' do
      expect(freelancer_profile.user).to eq(user)
    end

    context 'freelancer_sectors, freelancer_real_estate_skills, freelancer_softwares' do
      let!(:freelancer_sector) { FactoryBot.create(:freelancer_sector, freelancer_profile: freelancer_profile) }
      let!(:sector) { freelancer_sector.sector }
      let!(:freelancer_real_estate_skill) { FactoryBot.create(:freelancer_real_estate_skill, freelancer_profile: freelancer_profile) }
      let!(:real_estate_skill) { freelancer_real_estate_skill.real_estate_skill }
      let!(:freelancer_software) { FactoryBot.create(:freelancer_software, freelancer_profile: freelancer_profile) }
      let!(:software) { freelancer_software.software }
      let!(:freelancer_certification) { FactoryBot.create(:freelancer_certification, freelancer_profile: freelancer_profile) }
      let!(:certification) { freelancer_certification.certification }

      it 'can have many freelancer_sectors' do
        expect(freelancer_profile.freelancer_sectors).to include(freelancer_sector)
      end

      it 'can have many freelance_real_estate_skills' do
        expect(freelancer_profile.freelancer_real_estate_skills).to include(freelancer_real_estate_skill)
      end

      it 'can have many freelancer_softwares' do
        expect(freelancer_profile.freelancer_softwares).to include(freelancer_software)
      end

      it 'can have many freelancer_certificates' do
        expect(freelancer_profile.freelancer_certifications).to include(freelancer_certification)
      end

      it 'getting destroyed destroys freelancer_sectors, freelance_real_estate_skills, freelancer_softwares, freelancer_certifications but not parent sectors, real_estate_skills, softwares, certificates' do
        expect(FreelancerSector.exists?(freelancer_sector.id)).to be_truthy
        expect(FreelancerRealEstateSkill.exists?(freelancer_real_estate_skill.id)).to be_truthy
        expect(FreelancerSoftware.exists?(freelancer_software.id)).to be_truthy
        expect(FreelancerCertification.exists?(freelancer_certification.id)).to be_truthy

        freelancer_profile.destroy

        expect(FreelancerSector.exists?(freelancer_sector.id)).to be_falsey
        expect(FreelancerRealEstateSkill.exists?(freelancer_real_estate_skill.id)).to be_falsey
        expect(FreelancerSoftware.exists?(freelancer_software.id)).to be_falsey
        expect(FreelancerCertification.exists?(freelancer_certification.id)).to be_falsey

        expect(Sector.exists?(sector.id)).to be_truthy
        expect(RealEstateSkill.exists?(real_estate_skill.id)).to be_truthy
        expect(Software.exists?(software.id)).to be_truthy
        expect(Certification.exists?(certification.id)).to be_truthy
      end

      it 'can have sectors through freelancer_sectors' do
        expect(freelancer_profile.sectors).to include(freelancer_sector.sector)
      end

      it 'can have real_estate_skills through freelancer_real_estate_skills' do
        expect(freelancer_profile.real_estate_skills).to include(freelancer_real_estate_skill.real_estate_skill)
      end

      it 'can have softwares through freelancer_softwares' do
        expect(freelancer_profile.softwares).to include(freelancer_software.software)
      end

      context 'interview requests' do
        let(:employer_user)  { FactoryBot.create(:user) }
        let(:employer_profile) { FactoryBot.create(:employer_profile, user: employer_user) }
        let(:freelancer_user)  { FactoryBot.create(:user) }
        let!(:freelancer_profile) { FactoryBot.create(:freelancer_profile, user: freelancer_user) }
        let!(:interview_request) { FactoryBot.create(:interview_request, employer_profile: employer_profile, freelancer_profile: freelancer_profile) }

        it 'can have many interview_requests' do
          expect(freelancer_profile.interview_requests).to include(interview_request)
        end

        it 'getting destroyed destroys interview_requests' do
          expect { freelancer_profile.destroy }.to change { InterviewRequest.count }.by(-1)
        end
      end

    end
  end

  context 'Methods' do
    describe 'curation states' do
      it '#accepted?' do
        freelancer_profile.update(curation: 'accepted')
        expect(freelancer_profile.accepted?).to be_truthy
        expect(freelancer_profile.declined?).to be_falsey
        expect(freelancer_profile.pending?).to be_falsey
      end
      it '#declined?' do
        freelancer_profile.update(curation: 'declined')
        expect(freelancer_profile.accepted?).to be_falsey
        expect(freelancer_profile.declined?).to be_truthy
        expect(freelancer_profile.pending?).to be_falsey
      end
      it '#pending?' do
        freelancer_profile.update(curation: 'pending')
        expect(freelancer_profile.accepted?).to be_falsey
        expect(freelancer_profile.declined?).to be_falsey
        expect(freelancer_profile.pending?).to be_truthy
      end
    end

    it '#ready_for_submission?' do
      freelancer_profile.update(draft: true, curation: :pending)
      expect(freelancer_profile.ready_for_submission?).to be_truthy
      freelancer_profile.update(draft: true, curation: :accepted)
      expect(freelancer_profile.reload.ready_for_submission?).to be_falsey
      freelancer_profile.update(draft: true, curation: :declined)
      expect(freelancer_profile.reload.ready_for_submission?).to be_falsey
      freelancer_profile.update(draft: false, curation: :pending)
      expect(freelancer_profile.reload.ready_for_submission?).to be_falsey
      freelancer_profile.update(draft: false, curation: :accepted)
      expect(freelancer_profile.reload.ready_for_submission?).to be_falsey
      freelancer_profile.update(draft: false, curation: :declined)
      expect(freelancer_profile.reload.ready_for_submission?).to be_falsey
    end

    describe 'user fields' do
      it 'inherits first_name, last_name, full_name, email and location from user' do
        expect(freelancer_profile.first_name).to eq(freelancer_profile.user.first_name)
        expect(freelancer_profile.last_name).to eq(freelancer_profile.user.last_name)
        expect(freelancer_profile.full_name).to eq(freelancer_profile.user.full_name)
        expect(freelancer_profile.email).to eq(freelancer_profile.user.email)
        expect(freelancer_profile.location).to eq(freelancer_profile.user.location)
      end
    end
  end
end
