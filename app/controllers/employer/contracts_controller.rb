# frozen_string_literal: true

class Employer::ContractsController < ApplicationController
  include CreateContract

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

  def make_an_offer_without_job
    @contract = if job_id.present?
                  create_contract(make_an_offer_params.merge(state: 'pending'))
                else
                  create_contract(make_an_offer_params_without_job.merge(state: 'pending'))
                end

    close_job_if_offer_is_made
    FreelancerMailer.offer_made(@contract).deliver_later
    create_make_an_offer_flash_notice

    redirect_to redirect_path_after_make_an_offer
  end

  def find_job
    respond_to do |format|
      format.json do
        render json: {
          job_id: job.id,
          job_title: job.title,
          job_description: job.short_description,
          contract_type: job.contract_type,
          pay_rate: job.pay_range_low
        }.to_json
      end
    end
  end

  private

  def create_contract(contract_params)
    current_user.employer_profile.contracts.create(contract_params)
  end

  def job_id
    params.dig(:make_an_offer, :job_id)
  end

  def redirect_path_after_make_an_offer
    return employer_contracts_path if params.dig(:make_an_offer, :redirect_reference) == 'contracts'
    return employer_jobs_path if params.dig(:make_an_offer, :redirect_reference) == 'jobs'

    employer_interviews_path
  end
end
