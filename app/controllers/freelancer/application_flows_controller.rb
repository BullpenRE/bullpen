# frozen_string_literal: true

class Freelancer::ApplicationFlowsController < ApplicationController
  include Wicked::Wizard
  include LoggedInRedirects
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect, :incomplete_freelancer_profile_redirect
  steps :application_step_1, :application_step_2

  def show
    @user = current_user
    params[:start_flow].present? ? new_job_application : job_application

    respond_js_format(wizard_value(step))
  end

  def update
    @user = current_user

    job_application
    @time_zone = job_application.job.time_zone

    application_step_1_save || application_step_2_save
  end

  def application_step_1_save
    return false unless params[:job_application][:step] == 'application_step_1'

    if params[:job_application][:template].to_i == 1 && @user.job_applications.find_by(template: true).present?
      @user.job_applications.find_by(template: true).update(template: false)
    end
    job_application.update(step_1_params)

    respond_js_format(:application_step_2)

    true
  end

  def application_step_2_save

  end

  private

  def step_1_params
    params.require(:job_application).permit(:cover_letter, :template)
  end

  def respond_js_format(step)
    respond_to do |format|
      format.html
      format.js { render step.to_s, locals: { job_application: @job_application } }
    end
  end

  def new_job_application
    @job_application ||= current_user.job_applications.create(job_id: params[:job_id])
  end

  def job_application
    @job_application ||= current_user.job_applications.find_by(id: params[:job_application][:job_app_id])
  end
end
