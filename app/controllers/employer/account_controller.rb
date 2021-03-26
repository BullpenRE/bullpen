# frozen_string_literal: true

module Employer
  class AccountController < ApplicationController
    before_action :authenticate_user!

    def index
      @payment_accounts = employer_profile.payment_accounts
    end

    def destroy
      payment_account.destroy
      redirect_to employer_account_index_path
    end

    def update
      payment_account.update(account_update_params)
      redirect_to employer_account_index_path
    end

    private

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
