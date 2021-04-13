# frozen_string_literal: true

module Employer
  class StripeController < ApplicationController
    before_action :authenticate_user!, :initial_check, :non_employer_redirect, :employer_profile
    before_action :no_token_redirect

    def create_card
      response = Stripe::Customers::CardService.new(user_id: current_user.id,
                                                    customer_id: employer_profile.stripe_id_customer,
                                                    stripe_token: stripe_params[:stripeToken]).call
      if response.is_a?(Hash)
        redirect_to employer_account_index_path, alert: STRIPE_ERROR
      elsif params[:redirect_reference].present?
         redirect_to redirect_path
      else
        redirect_to employer_account_index_path, notice: 'Stripe: Card added successfully'
      end
    end

    def create_account
      response = Stripe::Customers::BankAccountService.new(user_id: current_user.id,
                                                           customer_id: employer_profile.stripe_id_customer,
                                                           stripe_token: stripe_params[:stripeToken]).call
      if response.is_a?(Hash)
        redirect_to employer_account_index_path, alert: STRIPE_ERROR
      elsif params[:redirect_reference].present?
        redirect_to redirect_path
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

    def token_present?
      stripe_params[:stripeToken].present?
    end

    def no_token_redirect
      return if token_present?

      redirect_to employer_account_index_path, alert: 'Stripe: token is invalid'
    end

    def redirect_path
      return employer_jobs_path if params[:redirect_reference] == 'jobs'
      return employer_contracts_path if params[:redirect_reference] == 'contracts'

      employer_interviews_path
    end
  end
end
