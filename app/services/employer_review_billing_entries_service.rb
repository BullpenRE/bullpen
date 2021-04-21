# frozen_string_literal: true

class EmployerReviewBillingEntriesService
  def initialize
    @timesheets = Timesheet.where(employer_notified_of_freelancer_changes: false)
  end

  def process
    @timesheets.each do |timesheet|
      next if timesheet.disputed? && timesheet.payment_date_in_future?

      EmployerMailer.hours_was_updated(timesheet).deliver_later
      timesheet.update(employer_notified_of_freelancer_changes: true)
    end
  end
end
