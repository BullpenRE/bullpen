# frozen_string_literal: true

module Users
  module Authorizers
    class GoogleAuthorizer < BaseAuthorizer

      def initialize(token, params)
        @token = token
        @params = params
      end

      def src
        @params[:src]
      end

      def email
        @token.email_address
      end

      def provider
        'google'
      end

      def user_data
        {
          uid: uid,
          first_name: first_name,
          last_name: last_name,
          email: email,
          provider: provider
        }
      end

      protected

      def uid
        @token.user_id
      end

      def first_name
        @token.given_name
      end

      def last_name
        @token.family_name
      end

    end
  end
end
