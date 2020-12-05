require 'rails_helper'

describe EmployersPresenter::FreelancersFilter do
  let!(:freelancer_with_obscure_sector) { FactoryBot.create(:freelancer_profile, :complete) }
  let!(:freelancer_with_obscure_real_state_skill) { FactoryBot.create(:freelancer_profile, :complete) }
  let!(:freelancer_with_obscure_software) { FactoryBot.create(:freelancer_profile, :complete) }

  let!(:obscure_sector) { FactoryBot.create(:sector, description: 'Strange Sector') }
  let!(:obscure_real_state_skill) { FactoryBot.create(:real_estate_skill, description: 'Strange Skill') }
  let!(:obscure_software) { FactoryBot.create(:software, description: 'Strange Software Program') }

  let!(:obscure_freelancer_sector) { FactoryBot.create(:freelancer_sector, freelancer_profile: freelancer_with_obscure_sector, sector: obscure_sector) }
  let!(:obscure_freelancer_real_state_skill) { FactoryBot.create(:freelancer_real_estate_skill, freelancer_profile: freelancer_with_obscure_real_state_skill, real_estate_skill: obscure_real_state_skill) }
  let!(:obscure_freelancer_software) { FactoryBot.create(:freelancer_software, freelancer_profile: freelancer_with_obscure_software, software: obscure_software) }


  it 'factories are set up properly' do
    expect(freelancer_with_obscure_sector.sectors).to include(obscure_sector)
    expect(freelancer_with_obscure_real_state_skill.real_estate_skills).to include(obscure_real_state_skill)
    expect(freelancer_with_obscure_software.softwares).to include(obscure_software)
  end

  it 'instantiates' do
    expect(EmployersPresenter::FreelancersFilter.new).to be_truthy
  end

  describe '#valid?' do
    context 'returns true if' do
      it 'a valid sector_id is passed' do
        expect(EmployersPresenter::FreelancersFilter.new(sector_ids:[obscure_sector.id]).valid?).to be_truthy
      end
      it 'a valid skill_id is passed' do
        expect(EmployersPresenter::FreelancersFilter.new(real_estate_skill_ids:[obscure_real_state_skill.id]).valid?).to be_truthy
      end
      it 'a valid software_id is passed' do
        expect(EmployersPresenter::FreelancersFilter.new(software_ids:[obscure_software.id]).valid?).to be_truthy
      end
    end

    context 'returns false if' do
      it 'nothing is passed' do
        expect(EmployersPresenter::FreelancersFilter.new().valid?).to be_falsey
      end

      it 'empty arrays are passed' do
        expect(EmployersPresenter::FreelancersFilter.new(sector_ids: [], real_estate_skill_ids: [], software_ids: []).valid?).to be_falsey
      end

      it 'no valid ids are passed' do
        expect(EmployersPresenter::FreelancersFilter.new(sector_ids: [999], real_estate_skill_ids: [888], software_ids: [777]).valid?).to be_falsey
      end
    end
  end

  describe '#freelancer_profile_ids' do
    let(:freelancer_who_passes) { FactoryBot.create(:freelancer_profile) }

    context 'only one object of one type is passed' do
      let!(:filter) { EmployersPresenter::FreelancersFilter.new(sector_ids: [obscure_sector.id]) }
      it 'returns freelancers who match it' do
        expect(filter.freelancer_profile_ids).to include(freelancer_with_obscure_sector.id)
      end
      it 'does not return freelancers who do not match it' do
        expect(filter.freelancer_profile_ids).to_not include(freelancer_with_obscure_real_state_skill.id)
        expect(filter.freelancer_profile_ids).to_not include(freelancer_with_obscure_software.id)
      end
    end

    context 'one tag each for all the filters' do
      let!(:freelancer_who_passes_obscure_sector) { FactoryBot.create(:freelancer_sector, freelancer_profile: freelancer_who_passes, sector: obscure_sector) }
      let!(:freelancer_who_passes_obscure_real_estate_skill) { FactoryBot.create(:freelancer_real_estate_skill, freelancer_profile: freelancer_who_passes, real_estate_skill: obscure_real_state_skill) }
      let!(:freelancer_who_passes_obscure_software) { FactoryBot.create(:freelancer_software, freelancer_profile: freelancer_who_passes, software: obscure_software) }

      let(:filter) { EmployersPresenter::FreelancersFilter.new(sector_ids: [obscure_sector.id], real_estate_skill_ids: [obscure_real_state_skill.id], software_ids: [obscure_software.id]) }

      it 'returns only freelancers who match all three filter entries' do
        expect(filter.freelancer_profile_ids).to match_array([freelancer_who_passes.id])
      end
    end

    context 'two tags of one type of filter' do
      let!(:obscure_sector2) { FactoryBot.create(:sector, description: 'Strange Sector 2') }
      let!(:freelancer_who_passes_obscure_sector) { FactoryBot.create(:freelancer_sector, freelancer_profile: freelancer_who_passes, sector: obscure_sector) }
      let!(:freelancer_who_passes_obscure_sector2) { FactoryBot.create(:freelancer_sector, freelancer_profile: freelancer_who_passes, sector: obscure_sector2) }

      let(:filter) { EmployersPresenter::FreelancersFilter.new(sector_ids: [obscure_sector.id, obscure_sector2.id]) }

      it 'returns only freelancers who match all both of the same time of passed filters' do
        expect(filter.freelancer_profile_ids).to match_array([freelancer_who_passes.id])
      end
    end

    context 'two tags of two types of filters' do
      let!(:obscure_sector2) { FactoryBot.create(:sector, description: 'Strange Sector 2') }
      let!(:obscure_software2) { FactoryBot.create(:software, description: 'Strange Software Program 2') }
      let!(:freelancer_who_passes_obscure_sector) { FactoryBot.create(:freelancer_sector, freelancer_profile: freelancer_who_passes, sector: obscure_sector) }
      let!(:freelancer_who_passes_obscure_sector2) { FactoryBot.create(:freelancer_sector, freelancer_profile: freelancer_who_passes, sector: obscure_sector2) }
      let!(:freelancer_who_passes_obscure_software) { FactoryBot.create(:freelancer_software, freelancer_profile: freelancer_who_passes, software: obscure_software) }
      let!(:freelancer_who_passes_obscure_software2) { FactoryBot.create(:freelancer_software, freelancer_profile: freelancer_who_passes, software: obscure_software2) }

      let(:filter) { EmployersPresenter::FreelancersFilter.new(sector_ids: [obscure_sector.id, obscure_sector2.id], software_ids: [obscure_software.id, obscure_software2.id]) }

      it 'returns freelancer who match all' do
        expect(filter.freelancer_profile_ids).to match_array([freelancer_who_passes.id])
      end
    end
  end
end