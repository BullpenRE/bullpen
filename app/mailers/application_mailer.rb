# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'support@bullpenre.com'
  layout 'mailer'
end
