# frozen_string_literal: true

class Freelancer::AccountController < ApplicationController
  before_action :authenticate_user!, :stripe_added

  def index
    freelancer_profile
    if session[:turn_off] == 'new_job_alerts'
      freelancer_profile.update(new_jobs_alert: false)
      session.delete(:turn_off)
      flash[:notice] = 'You will no longer be sent emails when new jobs are posted'
    end
    @sectors = Sector.enabled.pluck(:description, :id)
  end

  private

  def freelancer_profile
    @freelancer_profile ||= current_user.freelancer_profile
  end

  def stripe_added
    @stripe_added ||= freelancer_profile.stripe_id_account.present?
  end
end
