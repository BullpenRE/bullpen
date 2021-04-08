# frozen_string_literal: true

class Public::FreelancerProfileController < ApplicationController

  def show
    certifications
    @freelancer_profile = FreelancerProfile.lookup(params[:slug])
    render 'errors/talent_not_found' if @freelancer_profile.blank?
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

  def view_contract
    session[:timesheet_id] = params[:timesheet_id]

    redirect_to employer_contracts_path
  end

  private

  def certifications
    @certifications ||= Certification.enabled.pluck(:description, :id)
  end
end
