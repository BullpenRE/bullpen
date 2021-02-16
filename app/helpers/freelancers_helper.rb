# frozen_string_literal: true

module FreelancersHelper
  def stripe_button_link
    stripe_url = 'https://connect.stripe.com/express/oauth/authorize'
    redirect_uri = stripe_connect_url
    client_id = ENV['STRIPE_CLIENT_ID']

    "#{stripe_url}?redirect_uri=#{redirect_uri}&client_id=#{client_id}"
  end
end
