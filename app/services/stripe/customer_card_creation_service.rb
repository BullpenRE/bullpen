# frozen_string_literal: true

# Required parameters, see https://stripe.com/docs/api/cards/create:
# to create 'cus_...' the customer_creation_service is used

#  {
#     'cus_JABNN2TI0vpZlS',
#     {source: 'tok_mastercard'}
#  }
# response - the card object with id like: "card_1IYZVvKL..."

module Stripe
  class CustomerCardCreationService
    def initialize(cus, card_token)
      @cus = cus
      @card_token = card_token
      @employer_profile = EmployerProfile.find_by(stripe_id_customer: @cus)
    end

    def call
      response = Stripe::Customer.create_source(@cus, { source: @card_token })
      @employer_profile.payment_accounts.create(prepare_attributes(response)) if response['id']
    rescue StandardError => e
      user_id = @employer_profile.user.id
      Rails.logger.info(
        "Error in CustomerCardCreationService impacting user id: #{user_id}, "\
        "stripe customer id: #{@cus}, "\
        "error details: #{e}"
      )

      { stripe_error: true }
    end

    private

    def convert_time(response)
      Date.new(response['exp_year'].to_i, response['exp_month'].to_i, -1).iso8601
    end

    def prepare_attributes(response)
      {
        id_stripe: response['id'],
        stripe_object: response['object'],
        last_four: response['last4'],
        fingerprint: response['fingerprint'],
        card_brand: response['brand'],
        card_cvc_check: response['cvc_check'], # right now Stripe sends null here
        card_expires: convert_time(response)
      }
    end
  end
end
