# frozen_string_literal: true

# Required parameters for bank account token, see https://stripe.com/docs/api/tokens/create_bank_account:
#  bank_account: {
#    country: 'US',
#    currency: 'usd',
#    account_holder_name: 'Jenny Rosen',
#    account_holder_type: 'individual',
#    routing_number: '110000000',
#    account_number: '000123456789',
#  }

module Stripe
  class BankTokenService
    def initialize(payment_account)
      @payment_account = payment_account
      @user = @payment_account.employer_profile.user
      @error_message = ''
    end

    def call
      response = Stripe::Token.create({
                                        bank_account: {
                                          country: @payment_account.country,
                                          currency: @payment_account.currency,
                                          account_holder_name: @user.full_name,
                                          account_holder_type: 'company',
                                          routing_number: @payment_account.bank_routing_number,
                                          account_number: @payment_account.account_number
                                        }
                                      })
      @error_message = response.message if response['message']
      response['id']
    rescue StandardError => e
      Rails.logger.info(
        "Error in BankTokenService impacting user id: #{@user.id}, "\
         "payment_acccount_id: #{@payment_account.id}, "\
         "error details: #{e}, "\
         "error_message: #{@error_message}"
      )

      { stripe_error: true }
    end
  end
end

