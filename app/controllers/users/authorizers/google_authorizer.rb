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

      def find_or_create_user!(merge_data = {})
        raise(EmailNotPresentError, 'No email present in token.email_address') unless email

        User.find_by(email: email) || User.create(new_user_params.merge(merge_data))
      end

      def new_user_params
        user_data.merge(
          password: Devise.friendly_token[6, 15].split('').push('!').shuffle.join,
          confirmed_at: Time.current
        )
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
