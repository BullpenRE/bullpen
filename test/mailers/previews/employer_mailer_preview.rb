# Preview all emails at http://localhost:3000/rails/mailers/employer_mailer
class EmployerMailerPreview < ActionMailer::Preview
  def new_job_application
    EmployerMailer.new_job_application(User.where(:role => 0).first, JobApplication.first)
  end
   def interview_request_declined
    EmployerMailer.interview_request_declined(InterviewRequest.first)
  end
end
