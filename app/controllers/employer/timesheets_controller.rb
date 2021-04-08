# frozen_string_literal: true

class Employer::TimesheetsController < ApplicationController
  before_action :authenticate_user!, :initial_check, :non_employer_redirect, :incomplete_employer_profile_redirect

  def update
    @contract = current_user.employer_profile.contracts.find_by(id: params[:timesheet][:contract_id])
    @timesheet = @contract.timesheets.find_by(id: params[:timesheet][:timesheet_id])
    disputed_billings = []
    @timesheet.billings.each do |billing|
      billing.update(update_params(billing))
      disputed_billings << billing if params["disputed-#{billing.id}"].present?
    end
    send_dispute_email(disputed_billings) if disputed_billings.any?

    redirect_to employer_contracts_path
  end

  private

  def update_params(billing)
    {
      state: params["disputed-#{billing.id}"].present? ? 'disputed' : 'pending',
      dispute_comments: params["disputed-#{billing.id}"].present? ? params[billing.id.to_s] : ''
    }
  end

  def send_dispute_email(disputed_billings)
    FreelancerMailer.dispute_was_submitted(@timesheet, disputed_billings).deliver_later

    flash[:notice] = "Your dispute has been sent to <b>#{@timesheet.contract.freelancer_profile.full_name}</b> "\
                      'for review. If the issue can not be resolved, please contact our '\
                      'at <a href="mailto:support@bullpenre.com?subject=support team">support@bullpenre.com</a>'
  end
end
