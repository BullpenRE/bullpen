require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe EmployerReviewBillingEntriesService do
  let!(:timesheet) { FactoryBot.create(:timesheet, employer_notified_of_freelancer_changes: false) }
  let!(:billing) { FactoryBot.create(:billing, timesheet: timesheet, work_done: timesheet.starts, contract: timesheet.contract) }
  let!(:service) { EmployerReviewBillingEntriesService.new }

  it 'should send mails to employer and employer_notified_of_freelancer_changes set to true' do
    expect { service.process }.
      to have_enqueued_job(ActionMailer::MailDeliveryJob).
        with('EmployerMailer', 'hours_was_updated', 'deliver_now', { args: [timesheet] })
    timesheet.reload
    expect(timesheet.employer_notified_of_freelancer_changes).to eq true
  end

  it 'should not send mails to employer and employer_notified_of_freelancer_changes will be false' do
    billing.update(state: 'disputed')
    expect { service.process }.
      to_not have_enqueued_job(ActionMailer::MailDeliveryJob).
        with('EmployerMailer', 'hours_was_updated', 'deliver_now', { args: [timesheet] })
    timesheet.reload
    expect(timesheet.employer_notified_of_freelancer_changes).to eq false
  end

  it 'should not send mails to employer and employer_notified_of_freelancer_changes will be true' do
    timesheet.update(employer_notified_of_freelancer_changes: true)
    expect { service.process }.
      to_not have_enqueued_job(ActionMailer::MailDeliveryJob).
        with('EmployerMailer', 'hours_was_updated', 'deliver_now', { args: [timesheet] })
    timesheet.reload
    expect(timesheet.employer_notified_of_freelancer_changes).to eq true
  end
end