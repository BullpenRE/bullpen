# frozen_string_literal: true

# Required parameters, see https://stripe.com/docs/api/customer_bank_accounts/create:
# to create 'cus_...' the customer_creation_service is used
# to create 'btok_...' the bank_token_service is used

#  {
#     'cus_JABNN2TI0vpZlS',
#     {source: 'btok_1IXr0d2eZvKYlo2C895y5SVL'}
#  }

module Stripe
  class CustomerBankAccountService
    def initialize(cus, bank_attributes)
      @cus = cus
      @bank_attributes = bank_attributes
      @employer_profile = EmployerProfile.find_by(stripe_id_customer: @cus)
      @error_message = ''
    end

    def call
      response = Stripe::Customer.create_source(@cus, { source: @bank_attributes })
      @error_message = response.message if response['message']
      @employer_profile.payment_accounts.create(prepare_attributes(response)) if response['id']
    rescue StandardError => e
      user_id = @employer_profile.user.id
      Rails.logger.info(
        "Error in CustomerBankAccountService impacting user id: #{user_id}, "\
        "stripe customer id: #{@cus}, "\
        "error details: #{e}, "\
        "error message: #{@error_message}"
      )

      { stripe_error: true }
    end

    private

    def prepare_attributes(response)
      {
        id_stripe: response['id'],
        stripe_object: response['object'],
        last_four: response['last4'],
        fingerprint: response['fingerprint'],
        bank_name: response['bank_name'],
        bank_status: response['status'],
        bank_routing_number: response['routing_number'],
        country: response['country'],
        currency: response['currency'],
        bank_account_number: @bank_account_number
      }
    end
  end
end
