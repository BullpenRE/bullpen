# frozen_string_literal: true

# Required parameters, see https://stripe.com/docs/api/customers/create

#  {
#    email: user_email@test.com
#  }

module Stripe
  module Customer
    class CreateUpdateService
      def initialize(user_id:, customer_id: '', card_token: '')
        @user = User.find_by(id: user_id)
        @customer_id = customer_id
        @card_token = card_token
      end

      def call
        if @customer_id
          stripe_customer = Stripe::Customer.retrieve({ id: @customer_id })
          update_customer(stripe_customer, @card_token) if stripe_customer && @card_token
        else
          stripe_customer = Stripe::Customer.create({ email: @user.email, source: @card_token })
        end
        @user.employer_profile.update(stripe_id_customer: stripe_customer['id']) if stripe_customer['id']
      rescue StandardError => e
        log_errors(e)
      end

      private

      def update_customer(stripe_customer, card_token)
        Stripe::Customer.update(stripe_customer.id, { source: card_token })
      end

      def log_errors(error_description)
        Rails.logger.info(
          "Error in CustomerCreationService impacting user id: #{@user.id}, "\
          "error details: #{error_description}"
        )
      end
    end
  end
end
