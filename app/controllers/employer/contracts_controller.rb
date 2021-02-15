# frozen_string_literal: true

class Employer::ContractsController < ApplicationController
  before_action :authenticate_user!, :initial_check, :non_employer_redirect,
                :incomplete_employer_profile_redirect

  def index
    @contracts = current_user.employer_profile.contracts.order(created_at: :desc)
  end

  def withdraw_offer
    contract = current_user.employer_profile.contracts.find_by(id: params[:id])
    contract.update(state: 'withdrawn')
    FreelancerMailer.offer_was_withdrawn(contract).deliver_later
  end
end
