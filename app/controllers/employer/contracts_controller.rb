# frozen_string_literal: true

class Employer::ContractsController < ApplicationController
  include LoggedInRedirects
  before_action :authenticate_user!, :initial_check, :non_employer_redirect,
                :incomplete_employer_profile_redirect

  def index
    @contracts = current_user.employer_profile.contracts.order(created_at: :desc)
  end

  def withdraw_offer
    @contracts = current_user.employer_profile.contracts.find_by(id: params[:id])
    @contracts.update(state: 'withdrawn')
    FreelancerMailer.offer_was_withdrawn(@contracts).deliver_later
  end
end
