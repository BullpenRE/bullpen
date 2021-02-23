# frozen_string_literal: true

class StripeController < ApplicationController
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect, :freelancer_profile

  def connect
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

  def dashboard
    account = Stripe::Account.retrieve(freelancer_profile.stripe_id_account)
    url = account.login_links.create.url

    respond_to do |format|
      format.json do
        render json: {
          url: url
        }, status: :created
      end
    end
  end

  private

  def freelancer_profile
    @freelancer_profile ||= current_user.freelancer_profile
  end

  def response
    @response ||= HTTParty.post('https://connect.stripe.com/oauth/token',
                                query: {
                                  client_secret: ENV['STRIPE_SECRET_KEY'],
                                  code: params[:code],
                                  grant_type: 'authorization_code'
                                })
  end
end
