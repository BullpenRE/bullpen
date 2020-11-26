# frozen_string_literal: true

class FreelancerMailer < ApplicationMailer
  default from: 'support@bullpenre.com'

  def freelancer_approved_email
    @user = params[:user]
    @url = ENV['WEBSITE_URL']
    mail(to: @user.email, subject: 'Congratulations - Welcome to Bullpen')
  end
end
