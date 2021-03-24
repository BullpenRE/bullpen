# frozen_string_literal: true

module Employer
  class StripeController < ApplicationController
    before_action :authenticate_user!, :initial_check, :non_employer_redirect, :employer_profile

    def create_customer
      response = Stripe::CustomerCreationService.new(current_user).call

      if response.is_a?(Hash)
        redirect_to employer_account_index_path, alert: STRIPE_ERROR
      else
        redirect_to employer_account_index_path, notice: 'Stripe: Customer added successfully'
      end
    end

    def create_card
      cus_id_absense_redirect unless employer_profile.stripe_id_customer.present?
      response = Stripe::CustomerCardCreationService.new(employer_profile.stripe_id_customer).call

      if response.is_a?(Hash)
        redirect_to employer_account_index_path, alert: STRIPE_ERROR
      else
        redirect_to employer_account_index_path, notice: 'Stripe: Card added successfully'
      end
    end

    def create_account
      return if true # temporary block this action till be figured out how it must be implemented

      btoken = Stripe::BankTokenService.new(payment_account_attributes).call
      redirect_to(employer_account_index_path, alert: btok_absense_alert) if btoken.is_a?(Hash)

      response = Stripe::CustomerBankAccountService.new(employer_profile.stripe_id_customer, btoken).call
      if response.is_a?(Hash)
        redirect_to employer_account_index_path, alert: STRIPE_ERROR
      else
        redirect_to employer_account_index_path, notice: 'Stripe: Bank account added successfully'
      end
    end

    private

    def employer_profile
      @employer_profile ||= current_user.employer_profile
    end

    def cus_id_absense_redirect
      redirect_to employer_account_index_path, alert: 'Stripe: Please add a Customer ID to send payouts'
    end

    def btok_absense_alert
      'There was a problem to get the bank token from Stripe. Try again later'
    end

    def payment_account_attributes
      {} # there is question what to put here for now
    end
  end
end
