# frozen_string_literal: true

class Employer::TimesheetsController < ApplicationController
  before_action :authenticate_user!, :initial_check, :non_employer_redirect, :incomplete_employer_profile_redirect

  def update
    @contract = current_user.employer_profile.contracts.find_by(id: params[:timesheet][:contract_id])
    @timesheet = @contract.timesheets.find_by(id: params[:timesheet][:timesheet_id])
    @timesheet.billings.each do |billing|
      billing.update(update_params(billing))
    end

    redirect_to employer_contracts_path
  end

  private

  def update_params(billing)
    {
      state: params["#{billing.id}"].present? && params["disputed-#{billing.id}"].present? ? 'disputed' : 'pending',
      dispute_comments: params["disputed-#{billing.id}"].present? ? params["#{billing.id}"] : ''
    }
  end
end
