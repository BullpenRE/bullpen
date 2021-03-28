# frozen_string_literal: true

class Freelancer::BillingsController < ApplicationController
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect, :incomplete_freelancer_profile_redirect

  def add_hours
    @contract = current_user.freelancer_profile.contracts.find_by(id: params[:billing][:contract_id])
    find_billing
    if @billing.present? && params[:commit] == 'Remove'
      @billing.destroy
    elsif @billing.present?
      if @billing.disputed?
        @billing.update(billings_params.merge(state: 'pending', dispute_resolved: Date.current))
      end
      @billing.update(billings_params)
    else
      @contract.billings.create(billings_params)
    end

    redirect_to freelancer_contracts_path
  end

  private

  def billings_params
    params.require(:billing).permit(:work_done, :hours, :minutes, :description)
  end

  def find_billing
    return unless params[:billing][:billing_id].present?

    @billing ||= @contract.billings.find_by(id: params[:billing][:billing_id])
  end
end
