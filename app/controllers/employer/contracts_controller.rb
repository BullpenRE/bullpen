# frozen_string_literal: true

class Employer::ContractsController < ApplicationController
  include LoggedInRedirects
  before_action :authenticate_user!, :initial_check, :non_employer_redirect,
                :incomplete_employer_profile_redirect

  def index
    @contracts = current_user.employer_profile.contracts.order(created_at: :desc)
    return unless session[:review_by_contract].present?

    @contract = @contracts.find { |c| c.id == session[:review_by_contract].to_i }
    session.delete(:review_by_contract)
  end

  def withdraw_offer
    contract = current_user.employer_profile.contracts.find_by(id: params[:id])
    contract.update(state: 'withdrawn')
    FreelancerMailer.offer_was_withdrawn(contract).deliver_later
  end
end
