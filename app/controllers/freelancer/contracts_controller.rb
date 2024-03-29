# frozen_string_literal: true

class Freelancer::ContractsController < ApplicationController
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect, :incomplete_freelancer_profile_redirect

  def index
    @contracts = current_user.freelancer_profile.contracts.hire_group.freelancer_visible.order(:state, created_at: :desc)
    return unless session[:timesheet_id].present?

    check_session_variable
    redirect_to freelancer_jobs_path if @contract.blank?
  end

  def decline_offer
    contract.update(state: 'declined')
    EmployerMailer.offer_was_declined(contract).deliver_later

    mixpanel_freelancer_contract_tracker('Decline Offer')
    redirect_to freelancer_jobs_path if current_user.freelancer_profile.contracts.hire_group.blank?
  end

  def accept_offer
    flash[:notice] = "You have accepted the <b>#{contract.title}</b>. Select <b>Add Hours</b> "\
                     'to log any completed work.'
    contract.update(state: 'accepted')
    mixpanel_freelancer_contract_tracker('Accept Offer')
    EmployerMailer.offer_was_accepted(contract).deliver_later
  end

  def close_contract
    mixpanel_freelancer_contract_tracker('Close Contract')
    contract.update(state: 'closed')
    EmployerMailer.contract_was_closed(contract).deliver_later
  end

  def delete_contract
    mixpanel_freelancer_contract_tracker('Delete Contract')
    contract.update(hide_from_freelancer: true)
  end

  private

  def contract
    @contract ||= current_user.freelancer_profile.contracts.find_by(id: params[:id])
  end

  def mixpanel_freelancer_contract_tracker(action)
    MixpanelWorker.perform_async(current_user.id, action, { 'user': current_user.email })
  end

  def check_session_variable
    timesheets = Timesheet.related_to_contracts(@contracts.ids)
    @timesheet = timesheets&.find_by(id: session[:timesheet_id])
    @contract = @timesheet&.contract
    session.delete(:timesheet_id)
  end
end
