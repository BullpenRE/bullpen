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

    job_application.update(step_1_params)

    respond_js_format(:application_step_2)

    true
  end

  def application_step_2_save
    return false unless params[:job_application][:step] == 'application_step_2'

    job_application.job.job_questions.each do |job_question|
      job_question.job_application_questions.create(
        job_application_id: job_application.id,
        answer: params["job_question_#{job_question.id}"]
      )
    end
    job_application.update(
      per_hour_bid: cleaned_per_hour_bid,
      available_during_work_hours: cleaned_available_during_work_hours
    )
    job_application.update(state: 'draft') if params[:button] == 'draft'

    redirect_to freelancer_jobs_path
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
    @job_application ||= current_user.job_applications
                           .find_by(id: (params[:job_app] || params[:job_application][:job_app_id]))
  end

  def cleaned_per_hour_bid
    params[:job_application][:per_hour_bid].split('$').reject(&:empty?).join.to_i
  end

  def cleaned_available_during_work_hours
    params[:job_application][:available_during_work_hours] == 'yes' ? true : false
  end
end
