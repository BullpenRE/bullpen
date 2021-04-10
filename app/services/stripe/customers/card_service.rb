# frozen_string_literal: true

module Stripe
  module Customers
    class CardService < BaseSourcesService

      protected

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

      private

      def convert_time(obj)
        Date.new(obj['exp_year'].to_i, obj['exp_month'].to_i, -1).iso8601
      end
    end
  end
end
