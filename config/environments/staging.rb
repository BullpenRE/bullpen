# Just use the production settings
require File.expand_path('../production.rb', __FILE__)

Rails.application.configure do
  # Here override any defaults

  host = ENV['DOMAIN_URL']

  # Setup copy/pasted from https://heroku.mailtrap.io/inboxes/1136108/messages
  # Click on My Inbox, SMTP Settings, then select RoR from Integrations
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :user_name => '3c17b298c43c62',
    :password => '540c0a40654388',
    :address => 'smtp.mailtrap.io',
    :domain => 'smtp.mailtrap.io',
    :port => '2525',
    :authentication => :cram_md5
  }

  config.action_mailer.asset_host = "https://#{host}"
  config.action_mailer.default_url_options = { host: host }
  config.action_mailer.default_url_options = { protocol: 'https', host: ENV['DOMAIN_URL'] }
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = true
end
