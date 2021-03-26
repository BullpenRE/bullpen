# frozen_string_literal: true

module Employer
  class StripeController < ApplicationController
    before_action :authenticate_user!, :initial_check, :non_employer_redirect, :employer_profile
    before_action :no_account_routing_redirect, only: :create_account

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
      response = Stripe::CustomerBankAccountService.new(employer_profile.stripe_id_customer,
                                                        bank_attributes).call
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

    def bank_attributes
      {
        'object': 'bank_account',
        'country': 'US',
        'currency': 'usd',
        'account_holder_name': current_user.full_name,
        'account_holder_type': 'company',
        'account_number': stripe_params[:bank_account_number],
        'routing_number': stripe_params[:bank_routing_number]
      }
    end

    def stripe_params
      params.require(:stripe).permit(:bank_account_number, :bank_routing_number)
    end

    def no_account_routing_redirect
      return if stripe_params[:bank_account_number].present? && stripe_params[:bank_routing_number].present?

      redirect_to employer_account_index_path, alert: 'Please add the ACH routing number and bank account number'
    end
  end
end
