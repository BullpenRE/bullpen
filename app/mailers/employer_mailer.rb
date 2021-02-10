# frozen_string_literal: true

class EmployerMailer < ApplicationMailer
  default from: 'support@bullpenre.com'

  def new_job_application(user, job_application)
    @user = user
    @job_application = job_application
    mail(to: job_application.job.user.email, subject: "New applicant for #{job_application.job.title}")
  end

  def job_application_was_withdrawn(job_application)
    @job_application = job_application
    @url = public_job_url(job_application.job.slug)
    mail(to: @job_application.job.user.email, subject: "#{@job_application.user.full_name} withdrew their application")
  end

  def interview_request_declined(interview_request)
    @interview_request = interview_request
    employer_email = interview_request.employer_profile.email
    mail(to: employer_email, subject: "Your interview request was declined by #{interview_request.freelancer_profile.full_name}")
  end

  def send_message(message)
    @message = message
    mail(to: @message.to_user.email, cc: @message.from_user.email,
         subject: "#{@message.from_user.full_name} sent you a message.")
  end

  def offer_was_declined(contract)
    @contract = contract
    employer_email = contract.employer_profile.email
    mail(to:  employer_email, subject: "Your offer was declined by #{contract.freelancer_profile.full_name}")
  end
end
