# Preview all emails at http://localhost:3000/rails/mailers/employer_mailer
class EmployerMailerPreview < ActionMailer::Preview
  def new_job_application
    EmployerMailer.new_job_application(User.where(:role => 0).first, JobApplication.last)
  end

  def job_application_was_withdrawn
    EmployerMailer.job_application_was_withdrawn(JobApplication.last)
  end

  def interview_request_declined
    EmployerMailer.interview_request_declined(InterviewRequest.last)
  end

  def send_message
    EmployerMailer.send_message(Message.find_by(from_user: User.freelancers))
  end

  def offer_was_accepted
    EmployerMailer.offer_was_accepted(Contract.last)
  end

  def contract_was_closed
    EmployerMailer.contract_was_closed(Contract.last)
  end

  def hours_was_updated
    EmployerMailer.hours_was_updated(Timesheet.last)
  end

  def review_pending_payment
    EmployerMailer.review_pending_payment(Timesheet.last)
  end
end
