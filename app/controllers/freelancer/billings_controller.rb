# frozen_string_literal: true

class Freelancer::BillingsController < ApplicationController
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect, :incomplete_freelancer_profile_redirect

  def update_hours
    @contract = current_user.freelancer_profile.contracts.find_by(id: params[:billing][:contract_id])
    create_billing || update_billing

    redirect_to freelancer_contracts_path
  end

  def destroy
    billing = Billing.find_by(id: params[:id])
    billing.destroy

    redirect_to freelancer_contracts_path
  end

  private

  def update_billing
    return unless billing.present?

    if billing.disputed?
      billing.update(billings_params.merge(state: 'pending', dispute_resolved: Date.current))
    else
      billing.update(billings_params)
    end

    true
  end

  def create_billing
    return false if billing.present? || params[:commit] == 'Remove'

    @contract.billings.create(billings_params)

    true
  end

  def billings_params
    params.require(:billing).permit(:work_done, :hours, :minutes, :description)
  end

  def billing
    return unless params[:billing][:billing_id].present?

    @billing ||= @contract.billings.find_by(id: params[:billing][:billing_id])
  end
end
