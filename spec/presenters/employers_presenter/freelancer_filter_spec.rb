require 'rails_helper'

describe EmployersPresenter::FreelancersFilter do
  let!(:freelancer_with_obscure_sector) { FactoryBot.create(:freelancer_profile, :complete) }
  let!(:freelancer_with_obscure_real_state_skill) { FactoryBot.create(:freelancer_profile, :complete) }
  let!(:freelancer_with_obscure_software) { FactoryBot.create(:freelancer_profile, :complete) }

  let!(:obscure_sector) { FactoryBot.create(:sector, description: 'Strange Sector') }
  let!(:obscure_real_state_skill) { FactoryBot.create(:real_estate_skill, description: 'Strange Skill') }
  let!(:obscure_software) { FactoryBot.create(:software, description: 'Strange Software Program') }

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
end