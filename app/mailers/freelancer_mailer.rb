# frozen_string_literal: true

class FreelancerMailer < ApplicationMailer
  default from: 'support@bullpenre.com'

  def freelancer_approved
    set_params
    mail(to: @user.email, subject: 'Congratulations - Welcome to Bullpen')
  end

  def freelancer_rejected
    set_params
    mail(to: @user.email, subject: 'Your Bullpen Application')
  end

  def set_params
    @user = params[:user]
    @url = ENV['WEBSITE_URL']
  end
end
