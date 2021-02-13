# frozen_string_literal: true

class Freelancer::ContractsController < ApplicationController
  include LoggedInRedirects
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect, :incomplete_freelancer_profile_redirect

  def index
    @contracts = current_user.freelancer_profile.contracts.hire_group.freelancer_visible.order(:state, created_at: :desc)
  end

  def decline_offer
    contract = current_user.freelancer_profile.contracts.find_by(id: params[:id])
    contract.update(state: 'declined')
    EmployerMailer.offer_was_declined(contract).deliver_later

    redirect_to freelancer_jobs_path if current_user.freelancer_profile.contracts.hire_group.blank?
  end

  def accept_offer
    contract = current_user.freelancer_profile.contracts.find_by(id: params[:id])
    flash[:notice] = "You have accepted the <b>#{contract.title}</b>. Select <b>Add Hours</b> "\
                     'to log any completed work.'
    contract.update(state: 'accepted')
    EmployerMailer.offer_was_accepted(contract).deliver_later
  end

  def close_contract
    contract = current_user.freelancer_profile.contracts.find_by(id: params[:id])
    contract.update(state: 'closed')
    EmployerMailer.contract_was_closed(contract).deliver_later
  end

  def delete_contract
    contract = current_user.freelancer_profile.contracts.find_by(id: params[:id])
    contract.update(hide_from_freelancer: true)
  end
end
