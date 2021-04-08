# frozen_string_literal: true

class FreelancerMailer < ApplicationMailer
  default from: 'support@bullpenre.com'

  def freelancer_approved(freelancer_profile)
    @freelancer_profile = freelancer_profile
    @user = @freelancer_profile.user
    mail(to: @freelancer_profile.email, subject: 'Congratulations - Welcome to Bullpen')
  end

  def freelancer_rejected(freelancer_profile)
    @freelancer_profile = freelancer_profile
    @user = @freelancer_profile.user
    mail(to: @freelancer_profile.email, subject: 'Your Bullpen Application')
  end

  def interview_request(interview_request)
    @interview_request = interview_request
    @user = interview_request.freelancer_profile.user
    mail(to: @user.email, subject: 'Congratulations! You received an interview request.')
  end

  def send_message(message, title)
    @message = message
    @title = title
    @user = @message.to_user
    mail(to: @message.to_user.email, cc: @message.from_user.email,
         subject: "#{@message.from_user.full_name} sent you a message.")
  end

  def job_application_declined(job_application)
    @job_application = job_application
    @user = job_application.freelancer_profile.user
    mail(to: @user.email, subject: "#{job_application.job.title} is no longer available")
  end

  def interview_request_was_withdrawn(interview_request)
    @interview_request = interview_request
    @user = interview_request.freelancer_profile.user
    mail(to: @user.email, subject: 'Interview request withdrawn')
  end

  def posted_job(posted_job, freelancer_profile)
    @posted_job = posted_job
    @user = freelancer_profile.user
    mail(to: @user.email, subject: 'A new work opportunity has been added to Bullpen\'s job board')
  end

  def offer_made(contract)
    @contract = contract
    @user = contract.freelancer_profile.user
    mail(to: @user.email, subject: "Congratulations! #{contract.employer_profile.user.full_name} sent you a job offer")
  end

  def offer_update(contract)
    @contract = contract
    @user = contract.freelancer_profile.user
    mail(to: @user.email, subject: "#{contract.employer_profile.user.full_name} modified their job offer")
  end

  def review_was_create(review)
    @review = review
    @user = review.freelancer_profile.user
    mail(to: @user.email, subject: "#{review.employer_profile.user.full_name} left you a review")
  end

  def offer_was_withdrawn(contract)
    @contract = contract
    @user = contract.freelancer_profile.user
    mail(to: @user.email, subject: "#{contract.employer_profile.user.full_name} withdrew their #{contract.title} offer")
  end

  def review_was_update(review)
    @review = review
    @user = review.freelancer_profile.user
    mail(to:  @user.email, subject: "#{review.employer_profile.user.full_name} updated their review")
  end

  def reopen_contract(contract)
    @contract = contract
    employer_name = contract.employer_profile.user.full_name
    @user = contract.freelancer_profile.user
    mail(to: @user.email, subject: "Congratulations! #{employer_name} has reopened your contract")
  end

  def contract_was_closed(contract)
    @contract = contract
    @user = contract.freelancer_profile.user
    mail(to: @user.email, subject: "#{contract.employer_profile.full_name} closed the #{contract.title} contract.")
  end
end
