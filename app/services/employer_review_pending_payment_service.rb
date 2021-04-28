# frozen_string_literal: true

class EmployerReviewPendingPaymentService
  def initialize
    @timesheets = Timesheet.previous_week
  end

  def process
    @timesheets.each do |timesheet|
      next if timesheet.dispute_deadline != Date.current.strftime('%b %e')

      EmployerMailer.review_pending_payment(timesheet).deliver_later
    end
  end
end
