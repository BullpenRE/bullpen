# frozen_string_literal: true

class EmployerMailer < ApplicationMailer
  default from: 'support@bullpenre.com'

  def new_job_application(user, job_application)
    @user = user
    @job_application = job_application
    mail(to: job_application.job.user.email, subject: "New applicant for #{job_application.job.title}")
  end
end
