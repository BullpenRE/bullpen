# frozen_string_literal: true

class Freelancer::ApplicationFlowsController < ApplicationController
  include Wicked::Wizard
  include LoggedInRedirects
  include ApplicationFlowsHelper
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect, :incomplete_freelancer_profile_redirect
  steps :application_step_1, :application_step_2, :preview_application

  def show
    @user = current_user
    params[:start_flow].present? ? new_job_application : job_application
    pre_populate_answers if wizard_value(step) == :application_step_1

    respond_js_format(wizard_value(step))
  end

  def update
    @user = current_user

    params[:job_application][:job_application_id].blank? ? new_job_application : job_application
    @time_zone = job_application&.job&.time_zone
    pre_populate_answers

    application_step_1_save || application_step_2_save || preview_application_save
  end

  def application_step_2_save
    return false unless params[:job_application][:step] == 'application_step_2'

    job_application.update(step_2_params)
    if params[:button] == 'draft'
      job_application.update(state: 'draft')
      flash_notice(true)
      redirect_to freelancer_applications_path
    elsif params[:button] == 'back'
      respond_js_format(:application_step_1)
    else
      respond_js_format(:preview_application)
    end

    true
  end

  def application_step_1_save
    return false unless params[:job_application][:step] == 'application_step_1'

    job_application.update(
      per_hour_bid: cleaned_per_hour_bid(params[:job_application][:per_hour_bid]),
      available_during_work_hours: params[:job_application][:available_during_work_hours],
      state: 'draft'
    )
    job_application.job_application_questions.destroy_all
    job_application.job.job_questions.each do |job_question|
      job_question.job_application_questions.create(
        job_application_id: job_application.id,
        answer: params["job_question_#{job_question.id}"]
      )
    end
    pre_populate_cover_letter_work_sample

    respond_js_format(:application_step_2)

    true
  end

  def preview_application_save
    return false unless params[:job_application][:step] == 'preview_application'

    if params[:button] == 'draft'
      job_application.update(state: 'draft')
      flash_notice(true)
    else
      job_application.update(state: 'applied')
      flash_notice(false)
    end
    redirect_to freelancer_applications_path
  end

  private

  def flash_notice(draft)
    flash[:notice] = if draft
                      '<i class="far fa-check-circle"></i> <strong> Success!</strong> '\
                      "A draft was created for #{job_application.job.title.capitalize}."
                     else
                       '<i class="far fa-check-circle"></i> <strong> Success!</strong> '\
                       "#{job_application.job.title.capitalize} was applied for."
                     end

  end

  def pre_populate_answers
    if job_application.job_application_questions.any?
      @answers = {}
      job_application.job_application_questions.each do |job_application_question|
        @answers.store(job_application_question.job_question.id, job_application_question.answer)
      end
    end
  end

  def application_template
    @application_template ||= @user.job_applications.where.not(id: job_application.id).find_by(template: true)
  end

  def pre_populate_cover_letter_work_sample
    return if application_template.blank?

    job_application.update(cover_letter: application_template.cover_letter) if job_application.cover_letter.blank?
    job_application.work_sample.attach(application_template.work_sample.blob) if !job_application.work_sample.attached?
  end

  def step_2_params
    params.require(:job_application).permit(:cover_letter, :template)
  end

  def respond_js_format(step)
    respond_to do |format|
      format.html
      format.js do  render step.to_s, locals: {
        job_application: @job_application,
        job_id: params[:job_id],
        answers: @answers.presence
      }
      end
    end
  end

  def new_job_application
    @job_application ||= current_user.job_applications.build(job_id: (params[:job_id] || params[:job_application][:job_id]))
  end

  def job_application
    @job_application ||= current_user.job_applications
                           .find_by(id: (params[:job_app] || params[:job_application][:job_application_id]))
  end
end
