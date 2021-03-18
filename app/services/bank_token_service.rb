# frozen_string_literal: true

class BankTokenService
  def initialize(country, currency, account_number)
    @country = country
    @currency = currency
    @account_number = account_number
  end

  def call
    Stripe::Token.create({
                           bank_account: {
                             country: @country,
                             currency: @currency,
                             account_number: @account_number
                           }
                         }).id
  rescue StandardError => e
    Rails.logger.info "Error in bank_token_service.rb impacting account_number #{account_number}: #{e}"

    { stripe_error: true }
  end
end
