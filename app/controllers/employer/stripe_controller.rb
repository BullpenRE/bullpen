# frozen_string_literal: true

module Employer
  class StripeController < ApplicationController
    before_action :authenticate_user!, :initial_check, :non_employer_redirect, :employer_profile
    before_action :stripe_response_error

    def create_customer
      Stripe::Customer.create({ email: current_user.email })
      redirect_to employer_account_index_path, notice: 'Stripe: Customer added successfully'

    rescue StandardError => e
      Rails.logger
           .info "Error in employer/stripe_controller.rb#create_customer impacting user_id #{current_user.id}: #{e}"

      redirect_to employer_account_index_path, alert: STRIPE_ERROR
    end

    def create_card
      cus_id_absense_redirect unless employer_profile.stripe_customer_id_account.present?

      card_object
      redirect_to employer_account_index_path, notice: 'Stripe: Card added successfully'
    end

    def create_account
      btok_absense_redirect unless bank_token

      bank_account_object
      redirect_to employer_account_index_path, notice: 'Stripe: Account added successfully'
    end

    private

    def card_object
      @card_object ||= Stripe::Customer.create_source(employer_profile.stripe_customer_id_account,
                                                      { source: 'tok_mastercard' })
    rescue StandardError => e
      Rails.logger
           .info "Error in employer/stripe_controller.rb#card_object impacting user_id #{current_user.id}: #{e}"

      redirect_to employer_account_index_path, alert: STRIPE_ERROR
    end

    def bank_account_object
      cus_id_absense_redirect unless employer_profile.stripe_customer_id_account.present?

      @bank_account_object ||= Stripe::Customer.create_source(employer_profile.stripe_customer_id_account,
                                                              { source: bank_token })
    rescue StandardError => e
      Rails.logger
           .info "Error in employer/stripe_controller.rb#bank_account_object impacting user_id #{current_user.id}: #{e}"

      redirect_to employer_account_index_path, alert: STRIPE_ERROR
    end

    def bank_token
      return unless payment_account.present?

      response = BankTokenService.new(payment_account.country,
                                      payment_account.currency,
                                      payment_account.account_number).call
      if response.is_a?(Hash)
        redirect_to employer_account_index_path, alert: STRIPE_ERROR
      else
        response
      end
    end

    def employer_profile
      @employer_profile ||= current_user.employer_profile
    end

    def payment_account
      # where to get it?
      employer_profile.payment_accounts.first
    end

    def cus_id_absense_redirect
      redirect_to employer_account_index_path, alert: 'Stripe: Please add a Customer ID to send payouts'
    end

    def btok_absense_redirect
      redirect_to employer_account_index_path,
                  alert: 'There was a problem to get the bank token from Stripe. Try again later'
    end
  end
end
