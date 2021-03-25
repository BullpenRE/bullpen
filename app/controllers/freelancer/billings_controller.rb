# frozen_string_literal: true

class Freelancer::BillingsController < ApplicationController
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect, :incomplete_freelancer_profile_redirect

  def add_hours
    @contract = current_user.freelancer_profile.contracts.find_by(id: params[:billing][:contract_id])
    @contract.billings.create(billings_params)

    redirect_to freelancer_contracts_path
  end

  private

  def billings_params
    params.require(:billing).permit(:work_done, :hours, :minutes, :description)
  end
end
