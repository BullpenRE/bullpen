# frozen_string_literal: true

module Employer
  class StripeController < ApplicationController
    before_action :authenticate_user!, :initial_check, :non_employer_redirect, :employer_profile
    before_action :stripe_response_error

    def create_customer

      redirect_to employer_account_index_path, notice: 'Stripe: Customer added successfully'
    end

    def create_card

      redirect_to employer_account_index_path, notice: 'Stripe: Card added successfully'
    end

    def create_account

      redirect_to employer_account_index_path, notice: 'Stripe: Account added successfully'
    end

    private

    def card_object
      @card_object ||= nil # create service for this
    end

    def bank_account_object
      @bank_account_object ||= nil # create service for this
    end

    def stripe_response_error
      return unless stripe_response.parsed_response.key?('error')

      redirect_to employer_account_index_path, notice: stripe_response.parsed_response['error_description']
    end

    def employer_profile
      @employer_profile ||= current_user.employer_profile
    end
  end
end
