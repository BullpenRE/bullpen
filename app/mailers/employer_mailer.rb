# frozen_string_literal: true

class EmployerMailer < ApplicationMailer
  default from: 'support@bullpenre.com'

  def new_job_application(user, job_application)
    @user = user
    @job_application = job_application
    mail(to: job_application.job.user.email, subject: "New applicant for #{job_application.job.title}")
  end

  def interview_request_declined(interview_request)
    @interview_request = interview_request
    employer_email = interview_request.employer_profile.email
    mail(to: employer_email, subject: "Your interview request was declined by #{interview_request.freelancer_profile.full_name}")
  end
end
