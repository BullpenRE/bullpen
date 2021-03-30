class GenerateBillingTimesheets < ActiveRecord::Migration[6.1]
  def up
    Billing.where(timesheet_id: nil).each(&:attach_to_relevant_timesheet)
  end
end
