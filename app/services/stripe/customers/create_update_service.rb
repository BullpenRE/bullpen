# frozen_string_literal: true

module Stripe
  module Customers
    class CreateUpdateService
      def initialize(user_id:, customer_id: '', card_token: '')
        @user = User.find_by(id: user_id)
        @customer_id = customer_id
        @card_token = card_token
      end

      def call
        update_existing_customer if @customer_id.present? && @card_token.present?
        create_customer unless @customer_id.present?
      rescue StandardError => e
        log_errors(e)
        { stripe_error: true }
      end

      private

      def log_errors(error_description)
        Rails.logger.info(
          "Error in Customers::CreateUpdateService impacting user id: #{@user.id}, "\
          "error details: #{error_description}"
        )
      end

      def update_existing_customer
        obj = Stripe::Customer.create_source(@customer_id, { source: @card_token })
        @user.employer_profile.payment_accounts.create(prepare_attributes(obj)) if obj['id']
      end

      def create_customer
        obj = Stripe::Customer.create({ email: @user.email, source: @card_token })
        @user.employer_profile.update(stripe_id_customer: obj['id']) if obj['id'].present?
        return unless @card_token.present? && obj['fingerprint']

        @user.employer_profile.payment_accounts.create(prepare_attributes(obj))
      end

      def convert_time(obj)
        Date.new(obj['exp_year'].to_i, obj['exp_month'].to_i, -1).iso8601
      end

      def prepare_attributes(obj)
        {
          id_stripe: obj['id'],
          stripe_object: obj['object'],
          last_four: obj['last4'],
          fingerprint: obj['fingerprint'],
          card_brand: obj['brand'],
          card_cvc_check: obj['cvc_check'],
          card_expires: convert_time(obj)
        }
      end
    end
  end
end
