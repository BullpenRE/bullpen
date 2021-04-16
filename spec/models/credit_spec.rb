require 'rails_helper'

RSpec.describe Credit, type: :model do
  let(:timesheet) { FactoryBot.create(:timesheet) }
  let!(:credit) { FactoryBot.create(:credit, timesheet: timesheet) }

  it 'factories work' do
    expect(credit).to be_valid
  end

  context 'Relationships' do
    it 'belongs to a timesheet' do
      expect(Timesheet.exists?(timesheet.id)).to be_truthy
    end
  end

  context 'Scopes' do
    let!(:freelancer_credit) { FactoryBot.create(:credit, timesheet: timesheet, applied_to: 'freelancer') }
    let!(:employer_credit) { FactoryBot.create(:credit, timesheet: timesheet, applied_to: 'employer') }
    it '.employer, .freelancer' do
      expect(freelancer_credit.freelancer?).to eq true
      expect(Credit.freelancer).to include(freelancer_credit)
      expect(employer_credit.employer?).to eq true
      expect(Credit.employer).to include(employer_credit)
    end
  end
end
