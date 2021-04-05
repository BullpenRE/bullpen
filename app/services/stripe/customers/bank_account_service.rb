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
      def initialize(user_id:, customer_id: '', bank_token: '')
        @user = User.find_by(id: user_id)
        @customer_id = customer_id
        @bank_token = bank_token
      end

      def call
        update_existing_customer if @customer_id.present? && @bank_token.present?
        create_customer unless @customer_id.present?
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

      def update_existing_customer
        obj = Stripe::Customer.create_source(@customer_id, { source: @bank_token })
        @user.employer_profile.payment_accounts.create(prepare_attributes(obj)) if obj['id']
      end

      def create_customer
        obj = Stripe::Customer.create({ email: @user.email, source: @bank_token })
        @user.employer_profile.update(stripe_id_customer: obj['id']) if obj['id'].present?
        return unless @bank_token.present? && obj['fingerprint']

        @user.employer_profile.payment_accounts.create(prepare_attributes(obj))
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
