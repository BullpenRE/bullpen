# frozen_string_literal: true

class StripeController < ApplicationController
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect, :freelancer_profile

  def connect
    response = HTTParty.post('https://connect.stripe.com/oauth/token',
                             query: {
                               client_secret: ENV['STRIPE_SECRET_KEY'],
                               code: params[:code],
                               grant_type: 'authorization_code'
                             })

    if response.parsed_response.key?('error')
      redirect_to freelancer_account_index_path,
                  notice: response.parsed_response['error_description']
    else
      stripe_user_id = response.parsed_response['stripe_user_id']
      freelancer_profile.update_attribute(:stripe_id_account, stripe_user_id)

      redirect_to freelancer_account_index_path,
                  notice: 'Connected with Stripe successfully'
    end
  end

  private

  def freelancer_profile
    @freelancer_profile ||= current_user.freelancer_profile
  end
end
