# frozen_string_literal: true

class FreelancerMailer < ApplicationMailer
  default from: 'support@bullpenre.com'

  def freelancer_approved(freelancer_profile)
    @freelancer_profile = freelancer_profile
    mail(to: @freelancer_profile.email, subject: 'Congratulations - Welcome to Bullpen')
  end

  def freelancer_rejected(freelancer_profile)
    @freelancer_profile = freelancer_profile
    mail(to: @freelancer_profile.email, subject: 'Your Bullpen Application')
  end

  def interview_request(interview_request)
    @interview_request = interview_request
    freelancer_email = interview_request.freelancer_profile.user.email
    mail(to: freelancer_email, subject: 'Congratulations! You received an interview request.')
  end

  def send_message(message, title)
    @message = message
    @title = title
    mail(to: @message.to_user.email, cc: @message.from_user.email, subject: "#{@message.from_user.full_name} sent you a message.")
  end

  def job_application_declined(job_application)
    @job_application = job_application
    freelancer_email = job_application.user.email
    mail(to: freelancer_email, subject: "#{job_application.job.title} is no longer available")
  end
end
