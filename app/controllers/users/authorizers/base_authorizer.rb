# frozen_string_literal: true

module Users
  module Authorizers
    class BaseAuthorizer
      class EmailNotPresentError < StandardError; end

      def initialize(request)
        @request = request
      end

      def src
        @request.env['omniauth.params']['src']
      end

      def email
        auth_data['info']['email']
      end

      def provider
        raise NotImplementedError
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

      def auth_data
        @request.env['omniauth.auth']
      end

      protected

      def uid
        auth_data['uid']
      end

      def first_name
        auth_data['info']['first_name']
      end

      def last_name
        auth_data['info']['last_name']
      end
    end
  end
end
