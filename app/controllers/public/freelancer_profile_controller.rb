# frozen_string_literal: true

class Public::FreelancerProfileController < ApplicationController

  def show
    certifications
    @freelancer_profile = FreelancerProfile.lookup(params[:slug])
  end

  def request_interview
    session[:request_interview] = params[:request_interview]

    redirect_to employer_talent_index_path
  end

  def turn_off_new_job_alerts
    session[:turn_off] = params[:turn_off]

    redirect_to freelancer_account_index_url
  end

  def write_a_review
    session[:review_by_contract] = params[:review_by_contract]

    redirect_to employer_contracts_path
  end

  private

  def certifications
    @certifications ||= Certification.enabled.pluck(:description, :id)
  end
end
