# frozen_string_literal: true

class EmployerReviewBillingEntriesService
  def initialize(number_of_jobs: 1)
    @timesheets = Timesheet.where(employer_notified_of_freelancer_changes: false)
  end

  def process
    @timesheets.each do |timesheet|
      EmployerMailer.hours_was_updated(timesheet).deliver_later unless timesheet.disputed?
      timesheet.update(employer_notified_of_freelancer_changes: true)
    end
  end
end
