# frozen_string_literal: true

class Freelancer::ContractsController < ApplicationController
  include LoggedInRedirects
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect, :incomplete_freelancer_profile_redirect

  def index
    @contracts = current_user.freelancer_profile.contracts.hire_group.order(created_at: :desc)
  end

  def decline_offer
    contract = current_user.freelancer_profile.contracts.find_by(id: params[:id])
    contract.update(state: 'declined')
    EmployerMailer.offer_was_declined(contract).deliver_now
  end
end

