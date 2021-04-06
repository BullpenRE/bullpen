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
    class BankAccountService < BaseSourcesService

      protected

      def prepare_attributes(obj)
        {
          id_stripe: obj['id'],
          stripe_object: obj['object'],
          last_four: obj['last4'],
          fingerprint: obj['fingerprint'],
          bank_name: obj['bank_name'],
          bank_status: obj['status'],
          bank_routing_number: obj['routing_number']
        }
      end
    end
  end
end
