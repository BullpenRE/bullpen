# frozen_string_literal: true

module Employer
  class StripeController < ApplicationController
    before_action :authenticate_user!, :initial_check, :non_employer_redirect, :employer_profile
    before_action :no_account_routing_redirect, only: :create_account
    before_action :no_card_data_redirect, only: :create_card

    def create_card
      response = Stripe::CustomerCardCreationService.new(employer_profile.stripe_id_customer,
                                                         card_attributes).call
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

    def card_attributes
      {
        'object': 'card',
        'number': stripe_params[:card_number],
        'name': stripe_params[:name],
        'exp_year': stripe_params[:exp_year],
        'exp_month': stripe_params[:exp_month],
        'cvc': stripe_params[:cvc]
      }
    end

    def stripe_params
      params.require(:stripe).permit(:bank_account_number,
                                     :bank_routing_number,
                                     :name,
                                     :card_number,
                                     :exp_month,
                                     :exp_year,
                                     :cvc)
    end

    def no_account_routing_redirect
      return if stripe_params[:bank_account_number].present? && stripe_params[:bank_routing_number].present?

      redirect_to employer_account_index_path, alert: 'Please add the ACH routing number and bank account number'
    end

    def no_card_data_redirect
      redirect_to employer_account_index_path, alert: 'Stripe: card data is invalid'
    end
  end
end
