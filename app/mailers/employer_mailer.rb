# frozen_string_literal: true

class EmployerMailer < ApplicationMailer
  default from: 'support@bullpenre.com'

  def new_job_application(user)
    @user = user
    mail(to: user.email, subject: "New applicant for #{job_application.job.title}")
  end
end