# frozen_string_literal: true

class EmployerMailer < ApplicationMailer
  default from: 'support@bullpenre.com'

  def new_job_application(user, job_application)
    @user = user
    @job_application = job_application
    mail(to: job_application.job.employer_profile.email, subject: "New applicant for #{job_application.job.title}")
  end

  def job_application_was_withdrawn(job_application)
    @job_application = job_application
    @url = public_job_url(job_application.job.slug)
    @user = @job_application.job.employer_profile.user
    mail(to:  @user.email, subject: "#{@job_application.freelancer_profile.full_name} withdrew their application")
  end

  def interview_request_declined(interview_request)
    @interview_request = interview_request
    @user = interview_request.employer_profile.user
    mail(to: @user.email, subject: "Your interview request was declined by
                                    #{interview_request.freelancer_profile.full_name}")
  end

  def send_message(message)
    @message = message
    @user = @message.to_user
    mail(to: @user.email, cc: @message.from_user.email,
         subject: "#{@message.from_user.full_name} sent you a message.")
  end

  def offer_was_declined(contract)
    @contract = contract
    @user = contract.employer_profile.user
    mail(to: @user.email, subject: "Your offer was declined by #{contract.freelancer_profile.full_name}")
  end

  def offer_was_accepted(contract)
    @contract = contract
    @user = contract.employer_profile.user
    freelancer_profile = contract.freelancer_profile.email
    mail(to: @user.email, cc: freelancer_profile,
         subject: "Congratulations! Your offer was accepted by #{contract.freelancer_profile.full_name}")
  end

  def contract_was_closed(contract)
    @contract = contract
    @user = contract.employer_profile.user
    mail(to: @user.email, subject: "#{contract.freelancer_profile.full_name} closed the #{contract.title} contract.")
  end

  def hours_was_updated(timesheet)
    @timesheet = timesheet
    @user = timesheet.contract.employer_profile.user
    mail(to: @user.email, subject: "Review updated hours for week ending #{timesheet.ends}
                                    from #{timesheet.contract.freelancer_profile.full_name}.")
  end
end
