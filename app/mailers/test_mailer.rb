# frozen_string_literal: true

class TestMailer < ApplicationMailer
  def formatting
    @url = "http://#{ENV['DOMAIN_URL']}"
    mail(to: 'test@bullpenre.com', subject: 'Welcome to my awesome site')
  end
end
