# Preview all emails at http://localhost:3000/rails/mailers/employer_mailer
class EmployerMailerPreview < ActionMailer::Preview
  def new_job_application
    EmployerMailer.new_job_application(User.where(:role => 0).first, JobApplication.first)
  end

  def job_application_was_withdrawn
    EmployerMailer.job_application_was_withdrawn(JobApplication.first)
  end

  def interview_request_declined
    EmployerMailer.interview_request_declined(InterviewRequest.first)
  end

  def send_message
    EmployerMailer.send_message(Message.find_by(from_user: User.freelancers))
  end
end
