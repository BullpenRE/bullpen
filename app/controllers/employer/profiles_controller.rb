# frozen_string_literal: true

module Employer
  class ProfilesController < ApplicationController
    include LoggedInRedirects

    before_action :authenticate_user!, :initial_check, :non_employer_redirect, :employer_profile

    def update
      if @employer_profile.update(profile_params)
        redirect_to employer_account_index_path, flash: {
          notice: 'Company was updated successfully'
        }
      else
        redirect_to employer_account_index_path, flash: {
          alert: 'Company was not updated due errors'
        }
      end
    end

    private

    def employer_profile
      @employer_profile ||= current_user.employer_profile
    end

    def profile_params
      params.require(:employer_profile)
            .permit(:company_name,
                    :company_website,
                    :employee_count,
                    :category,
                    user_attributes: %i[location id])
    end
  end
end
