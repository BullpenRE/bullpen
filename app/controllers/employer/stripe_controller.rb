# frozen_string_literal: true

module Employer
  class StripeController < ApplicationController
    before_action :authenticate_user!, :initial_check, :non_employer_redirect, :employer_profile
    before_action :no_card_token_redirect, only: :create_card
    before_action :no_bank_token_redirect, only: :create_account

    def create_card
      response = Stripe::Customers::CreateUpdateService.new(user_id: current_user.id,
                                                            customer_id: employer_profile.stripe_id_customer,
                                                            card_token: stripe_params[:stripeToken]).call
      if response.is_a?(Hash)
        redirect_to employer_account_index_path, alert: STRIPE_ERROR
      else
        redirect_to employer_account_index_path, notice: 'Stripe: Card added successfully'
      end
    end

    def create_account
      response = Stripe::Customers::BankAccountService.new(user_id: current_user.id,
                                                           customer_id: employer_profile.stripe_id_customer,
                                                           bank_token: stripe_params[:bankToken]).call
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

    def stripe_params
      params.permit(:stripeToken, :authenticity_token)
    end

    def valid_card_input?
      stripe_params[:stripeToken].present?
    end

    def valid_bank_input?
      stripe_params[:bankToken].present?
    end

    def no_bank_token_redirect
      return if valid_bank_input?

      redirect_to employer_account_index_path, alert: 'Stripe: bank data is invalid'
    end

    def no_card_token_redirect
      return if valid_card_input?

      redirect_to employer_account_index_path, alert: 'Stripe: card data is invalid'
    end
  end
end
