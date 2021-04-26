# frozen_string_literal: true

Rails.application.configure do
  config.stripe.secret_key = ENV['STRIPE_SECRET_KEY']
  config.stripe.publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']
  config.stripe.signing_secret = ENV['STRIPE_SIGNING_SECRET']
end

