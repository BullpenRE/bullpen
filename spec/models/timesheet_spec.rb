require 'rails_helper'

RSpec.describe Timesheet, type: :model do
  let!(:timesheet) { FactoryBot.create(:timesheet) }
  let!(:billing) { FactoryBot.create(:billing, timesheet: timesheet, work_done: timesheet.starts, contract: timesheet.contract) }

  it 'factory works' do
    expect(timesheet).to be_valid
  end

  context 'Validations' do
    it 'starts and ends are defined' do
      timesheet.starts = nil
      expect(timesheet).to_not be_valid
      timesheet.starts = 3.weeks.ago
      timesheet.ends = nil
      expect(timesheet).to_not be_valid
    end

    it 'ends must be equal or after starts' do
      timesheet.ends = timesheet.starts
      expect(timesheet).to be_valid
      timesheet.ends = timesheet.starts - 1.day
      expect(timesheet).to_not be_valid
    end
  end

  context 'Relationships' do
    it 'has_many billings dependent nullify' do
      expect(timesheet.billings).to include(billing)
      timesheet.destroy
      expect(Billing.exists?(billing.id)).to be_truthy
      expect(billing.reload.timesheet_id).to be_nil
    end
  end

  context 'Scopes' do
    let!(:timesheet_1) { FactoryBot.create(:timesheet) }
    let!(:timesheet_2) { FactoryBot.create(:timesheet, contract_id: timesheet_1.contract_id) }

    it '#related_to_contracts' do
      expect(Timesheet.related_to_contracts([timesheet.contract_id, timesheet_1.contract_id])).to match_array [timesheet, timesheet_1, timesheet_2]
      expect(Timesheet.related_to_contracts([timesheet_1.contract_id])).to match_array [timesheet_1, timesheet_2]
    end
  end

  context 'Methods' do
    let!(:current_timesheet) { FactoryBot.create(:timesheet, starts: 1.minute.ago.beginning_of_week, ends: 1.minute.ago.end_of_week) }
    let!(:pending_timesheet) { FactoryBot.create(:timesheet, starts: 1.week.ago.beginning_of_week, ends: 1.week.ago.end_of_week) }
    it '#title' do
      expect(current_timesheet.title).to eq 'Current Hours'
      expect(pending_timesheet.title).to eq "Pending Payment on #{pending_timesheet.ends.next_occurring(:friday).strftime('%b %e')}"
    end
  end
end
