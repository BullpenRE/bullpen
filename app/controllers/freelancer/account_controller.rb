# frozen_string_literal: true

class Freelancer::AccountController < ApplicationController
  before_action :authenticate_user!, :stripe_id_account
  before_action :stripe_lookup, only: :stripe_data_lookup

  def index
    freelancer_profile
    if session[:turn_off] == 'new_job_alerts'
      freelancer_profile.update(new_jobs_alert: false)
      session.delete(:turn_off)
      flash[:notice] = 'You will no longer be sent emails when new jobs are posted'
    end
    @sectors = Sector.enabled.pluck(:description, :id)
  end

  def stripe_data_lookup
    respond_to do |format|
      format.json do
        render json: {
          account_data: @account_data,
          error: @stripe_error
        }, status: :ok
      end
    end
  end

  private

  def freelancer_profile
    @freelancer_profile ||= current_user.freelancer_profile
  end

  def stripe_id_account
    @stripe_id_account ||= freelancer_profile.stripe_id_account
  end

  def stripe_lookup
    @account_data = Stripe::Account.retrieve(stripe_id_account)
  rescue StandardError => e
    Rails.logger.info "!!!!! Error in account_controller.rb#stripe_lookup impacting user_id #{current_user.id}: #{e}"
    @stripe_error = STRIPE_ERROR
  end
end
