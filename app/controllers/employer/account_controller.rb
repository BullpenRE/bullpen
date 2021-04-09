# frozen_string_literal: true

module Employer
  class AccountController < ApplicationController
    before_action :authenticate_user!

    def index
      @payment_accounts = employer_profile.payment_accounts
    end

    def destroy
      delete_on_stripe = Stripe::Customer.delete_source(employer_profile.stripe_id_customer,
                                                        payment_account.id_stripe)
      (payment_account.destroy && redirect_to_index) if delete_on_stripe.deleted?
    rescue StandardError => e
      ::Rails.logger.info(
        "Error in AccountController#destroy impacting user id: #{current_user.id}, "\
        "error details: #{e}"
      )
      redirect_to employer_account_index_path, flash: {
        alert: 'Payment Source was not deleted due Stripe errors'
      }
    end

    def update
      payment_account.update(account_update_params)
      redirect_to_index
    end

    private

    def redirect_to_index
      redirect_to employer_account_index_path
    end

    def payment_account
      @payment_account ||= employer_profile.payment_accounts.find_by(id: params[:id])
    end

    def employer_profile
      @employer_profile ||= current_user.employer_profile
    end

    def account_update_params
      params.require(:account).permit(:is_default)
    end
  end
end
