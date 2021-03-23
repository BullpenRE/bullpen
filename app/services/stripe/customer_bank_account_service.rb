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
    def initialize(cus, btok)
      @cus = cus
      @btok = btok
      @employer_profile = EmployerProfile.find_by(stripe_id_customer: @cus)
      @error_message = ''
    end

    def call
      response = Stripe::Customer.create_source(@cus, { source: @btok })
      @error_message = response.message if response['message']
      @employer_profile.update(stripe_id_bank_account: response['id']) if response['id']
    rescue StandardError => e
      user_id = @employer_profile.user.id
      Rails.logger.info(
        "Error in CustomerBankAccountService impacting user id: #{user_id}, "\
        "stripe customer id: #{@cus}, "\
        "error details: #{e}, "\
        "error_message: #{@error_message}"
      )

      { stripe_error: true }
    end
  end
end
