require 'rails_helper'

RSpec.describe Timesheet, type: :model do
  let!(:timesheet) { FactoryBot.create(:timesheet) }
  let!(:billing) { FactoryBot.create(:billing, timesheet: timesheet, work_done: timesheet.ends, contract: timesheet.contract) }

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
    let!(:timesheet_week_ago) { FactoryBot.create(:timesheet, :skip_validate, ends: (Date.current - 1.week).next_occurring(:sunday), starts: (Date.current - 1.week).beginning_of_week) }
    let!(:timesheet_month_ago) { FactoryBot.create(:timesheet, :skip_validate, ends: (Date.current - 1.month).next_occurring(:sunday), starts: (Date.current - 1.month).beginning_of_week) }
    let!(:timesheet_with_no_billings) { FactoryBot.create(:timesheet) }
    let!(:timesheet_with_stripe_invoice) { FactoryBot.create(:timesheet, :with_stripe_invoice) }
    let!(:unprocessed_timesheet) { FactoryBot.create(:timesheet, contract_id: timesheet_with_stripe_invoice.contract_id) }
    let!(:disputed_timesheet) { FactoryBot.create(:timesheet) }
    let!(:disputed_billing) { FactoryBot.create(:billing, timesheet: disputed_timesheet, contract: disputed_timesheet.contract, work_done: disputed_timesheet.starts, state: 'disputed') }
    let!(:normal_billing) { FactoryBot.create(:billing, timesheet: unprocessed_timesheet, contract: unprocessed_timesheet.contract, work_done: unprocessed_timesheet.starts, state: 'pending') }

    before do
      timesheet_with_no_billings.update(description: 'timesheet_with_no_billings')
      timesheet_with_stripe_invoice.update(description: 'timesheet_with_stripe_invoice')
      unprocessed_timesheet.update(description: 'unprocessed_timesheet')
      disputed_timesheet.update(description: 'disputed_timesheet')
    end

    it '.related_to_contracts' do
      expect(Timesheet.related_to_contracts([timesheet.contract_id, timesheet_with_stripe_invoice.contract_id])).to match_array [timesheet, timesheet_with_stripe_invoice, unprocessed_timesheet]
      expect(Timesheet.related_to_contracts([timesheet_with_stripe_invoice.contract_id])).to match_array [timesheet_with_stripe_invoice, unprocessed_timesheet]
    end

    it '.paid' do
      expect(Timesheet.paid).to match_array [timesheet_with_stripe_invoice]
    end

    it '.disputed' do
      expect(Timesheet.disputed).to include(disputed_timesheet)
      expect(Timesheet.disputed).to_not include(timesheet_with_no_billings, unprocessed_timesheet)
    end

    describe '.ready_for_payment' do
      let!(:passed_paid_timesheet) { FactoryBot.create(:timesheet, :skip_validate, :with_stripe_invoice, ends: Date.yesterday) }
      let!(:current_paid_timesheet) { FactoryBot.create(:timesheet, :with_stripe_invoice, ends: Date.tomorrow) }
      let!(:passed_unpaid_timesheet) { FactoryBot.create(:timesheet, :skip_validate, ends: Date.yesterday) }
      let!(:current_unpaid_timesheet) { FactoryBot.create(:timesheet, ends: Date.tomorrow) }

      it 'return only timesheets with stripe_id_invoice=nil and ends<=Date.current' do
        expect(Timesheet.ready_for_payment).to include(passed_unpaid_timesheet)
        expect(Timesheet.ready_for_payment).to_not include(passed_paid_timesheet, current_paid_timesheet, current_unpaid_timesheet)
      end
    end

    it '#previous_week' do
      expect(Timesheet.previous_week).to include(timesheet_week_ago)
      expect(Timesheet.previous_week).to_not include(timesheet_month_ago)
    end
  end

  context 'Methods' do
    let!(:current_timesheet) { FactoryBot.create(:timesheet, starts: 1.minute.ago.beginning_of_week, ends: 1.minute.ago.end_of_week) }
    let!(:pending_timesheet) { FactoryBot.create(:timesheet, starts: 1.week.ago.beginning_of_week, ends: 1.week.ago.end_of_week) }
    let!(:pending_timesheet_billing_1) do
      FactoryBot.create(:billing,
                        timesheet: pending_timesheet,
                        work_done: pending_timesheet.ends,
                        contract: pending_timesheet.contract,
                        hours: 3, minutes: 30)
    end
    let!(:pending_timesheet_billing_2) do
      FactoryBot.create(:billing, :skip_validate,
                        timesheet: pending_timesheet,
                        work_done: pending_timesheet.starts,
                        contract: pending_timesheet.contract,
                        hours: 0, minutes: 15)
    end
    let!(:pending_timesheet_billing_2) do
      FactoryBot.create(:billing,
                        timesheet: pending_timesheet,
                        work_done: pending_timesheet.ends,
                        contract: pending_timesheet.contract,
                        hours: 0, minutes: 15)
    end
    let!(:pending_timesheet_billing_3) do
      FactoryBot.create(:billing, :skip_validate,
                        timesheet: pending_timesheet,
                        work_done: pending_timesheet.starts,
                        contract: pending_timesheet.contract,
                        state: 'paid',
                        hours: 10, minutes: 0)
    end
    let!(:pending_timesheet_billing_3) do
      FactoryBot.create(:billing,
                        timesheet: pending_timesheet,
                        work_done: pending_timesheet.ends,
                        contract: pending_timesheet.contract,
                        state: 'paid',
                        hours: 10, minutes: 0)
    end
    let!(:current_timesheet_billing_1) do
      FactoryBot.create(:billing,
                        :disputed,
                        timesheet: current_timesheet,
                        work_done: current_timesheet.ends,
                        contract: current_timesheet.contract,
                        hours: 1, minutes: 22)
    end
    let!(:current_timesheet_billing_2) do
      FactoryBot.create(:billing,
                        :disputed,
                        timesheet: current_timesheet,
                        work_done: current_timesheet.ends,
                        contract: current_timesheet.contract,
                        hours: 2, minutes: 11)
    end

    it '#title' do
      expect(current_timesheet.title(employer: false)).to eq 'Current Hours'
      expect(pending_timesheet.title(false)).to eq "Pending Payment on #{pending_timesheet.ends.next_occurring(:friday).strftime('%b %e')}"
      expect(pending_timesheet.title(employer: true)).to eq "Payment Due on #{pending_timesheet.ends.next_occurring(:friday).strftime('%b %e')}"
    end

    it '#total_usd' do
      expect(pending_timesheet.total_usd).to eq 3.75 * pending_timesheet.contract.pay_rate
      expect(current_timesheet.total_usd).to eq 3.55 * current_timesheet.contract.pay_rate
    end

    it '#total_hours_display' do
      expect(pending_timesheet.total_hours_display).to eq 3.75
      pending_timesheet_billing_2.update(hours: 4)
      expect(pending_timesheet.total_hours_display).to eq 7.75
      expect(current_timesheet.total_hours_display).to eq 3.55
    end

    it '#dispute_deadline' do
      expect(pending_timesheet.dispute_deadline).to eq (pending_timesheet.ends.next_occurring(:friday) - 1.day).strftime('%b %e')
      expect(current_timesheet.dispute_deadline).to eq (current_timesheet.ends.next_occurring(:friday) - 1.day).strftime('%b %e')
    end

    context '#employer_total_charge' do
      it 'calculates charges for pending billings only' do
        expect(pending_timesheet.employer_total_charge).to eq 3.75 * pending_timesheet.contract.pay_rate
        expect(current_timesheet.employer_total_charge).to eq 0
      end
    end
  end
end
