# frozen_string_literal: true

# Required parameters, see https://stripe.com/docs/api/customer_bank_accounts/create:
# to create 'cus_...' the customer_creation_service is used
# to create 'btok_...' the bank_token_service is used

#  {
#     'cus_JABNN2TI0vpZlS',
#     {source: 'btok_1IXr0d2eZvKYlo2C895y5SVL'}
#  }

module Stripe
  module Customers
    class BankAccountService
      def initialize(stripe_id_customer, bank_token)
        @stripe_id_customer = stripe_id_customer
        @bank_token = bank_token
        @employer_profile = EmployerProfile.find_by(stripe_id_customer: @stripe_id_customer)
        @user_id = @employer_profile.user.id
      end

      def call
        response = Stripe::Customer.create_source(@stripe_id_customer, { source: @bank_token })
        @employer_profile.payment_accounts.create(prepare_attributes(response)) if response['id']
      rescue StandardError => e
        log_errors(e)

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
          bank_routing_number: response['routing_number']
        }
      end

      def log_errors(error_description)
        Rails.logger.info(
          "Error in Customers::BankAccountService impacting user id: #{@user_id}, "\
          "stripe customer id: #{@stripe_id_customer}, "\
          "error details: #{error_description}"
        )
      end
    end
  end
end
