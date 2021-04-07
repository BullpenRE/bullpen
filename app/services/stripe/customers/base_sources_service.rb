# frozen_string_literal: true

module Stripe
  module Customers
    class BaseSourcesService

      attr_reader :stripe_token, :customer_id, :user

      def initialize(user_id:, customer_id: '', stripe_token: '')
        @user = User.find_by(id: user_id)
        @customer_id = customer_id
        @stripe_token = stripe_token
      end

      def call
        update_existing_customer if customer_id.present? && stripe_token.present?
        create_customer unless customer_id.present?
      rescue StandardError => e
        ::Rails.logger.info(
          "Error in Customers::BankAccountService impacting user id: #{user.id}, "\
          "stripe customer id: #{customer_id}, "\
          "error details: #{e}"
        )

        { stripe_error: true }
      end

      def update_existing_customer
        obj = Stripe::Customer.create_source(customer_id, { source: stripe_token })
        @user.employer_profile.payment_accounts.create(prepare_attributes(obj)) if obj['id']
      end

      # rubocop:disable Metrics/AbcSize
      def create_customer
        obj = Stripe::Customer.create({ email: user.email, source: stripe_token })
        user.employer_profile.update(stripe_id_customer: obj['id']) if obj['id'].present?
        return unless stripe_token.present? && obj['fingerprint']

        user.employer_profile.payment_accounts.create(prepare_attributes(obj))
      end
      # rubocop:enable Metrics/AbcSize
    end

    protected

    def prepare_attributes(_obj)
      raise NotImplementedError
    end
  end
end
