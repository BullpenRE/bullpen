# frozen_string_literal: true

class FreelancerMailer < ApplicationMailer
  default from: 'support@bullpenre.com'

  def freelancer_approved(user)
    @user = user
    mail(to: user.email, subject: 'Congratulations - Welcome to Bullpen')
  end

  def freelancer_rejected(user)
    @user = user
    mail(to: user.email, subject: 'Your Bullpen Application')
  end
end
