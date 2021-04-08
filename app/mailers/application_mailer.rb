# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'support@bullpenre.com'
  layout 'mailer'

  after_action :prevent_delivery_to_disabled_user

  private

  def prevent_delivery_to_disabled_user
    return unless @user.disable?

    mail.perform_deliveries = false
  end
end
