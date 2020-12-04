require 'rails_helper'

describe EmployersPresenter::FreelancersFilter do
  let!(:freelancer_with_obscure_sector) { FactoryBot.create(:freelancer_profile, :complete) }
  let!(:freelancer_with_obscure_skill) { FactoryBot.create(:freelancer_profile, :complete) }
  let!(:freelancer_with_obscure_software) { FactoryBot.create(:freelancer_profile, :complete) }

  let!(:obscure_sector) { FactoryBot.create(:sector) }
  let!(:obscure_skill) { FactoryBot.create(:skill) }
  let!(:obscure_software) { FactoryBot.create(:software) }

  it 'instantiates' do
    expect(EmployersPresenter::FreelancersFilter.new).to be_truthy
  end

  describe '#valid?' do
    context 'returns true if' do
      it 'a valid sector_id is passed' do
        expect(EmployersPresenter::FreelancersFilter.new(sector_ids:[obscure_sector.id]).valid?).to be_truthy
      end
      it 'a valid skill_id is passed' do
        expect(EmployersPresenter::FreelancersFilter.new(skill_ids:[obscure_skill.id]).valid?).to be_truthy
      end
      it 'a valid software_id is passed' do
        expect(EmployersPresenter::FreelancersFilter.new(software_ids:[obscure_software.id]).valid?).to be_truthy
      end
    end

    context 'returns false if' do

    end
    it 'returns false if nothing is passed to it, or no recognized sectors, skills and softwares' do

    end

  end
end