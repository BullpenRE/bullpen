# frozen_string_literal: true

class Freelancer::ApplicationFlowsController < ApplicationController
  include Wicked::Wizard
  include ApplicationHelper
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
      draft_flash_notice!
      redirect_to freelancer_applications_path
    elsif params[:button] == 'back'
      respond_js_format(:application_step_1)
    else
      respond_js_format(:preview_application)
    end

    mixpanel_freelancer_application_flow_tracker
    true
  end

  def application_step_1_save
    return false unless params[:job_application][:step] == 'application_step_1'

    job_application.update(
      bid_amount: clean_currency_entry(params[:job_application][:bid_amount]),
      available_during_work_hours: params[:job_application][:available_during_work_hours]
    )
    job_application.job_application_questions.destroy_all
    job_application.job.job_questions.each do |job_question|
      job_question.job_application_questions.create(
        job_application_id: job_application.id,
        answer: params["job_question_#{job_question.id}"]
      )
    end
    pre_populate_cover_letter_work_sample
    job_application.update(state: 'draft') if job_application.state.blank?
    respond_js_format(:application_step_2)

    mixpanel_freelancer_application_flow_tracker
    true
  end

  def preview_application_save
    return false unless params[:job_application][:step] == 'preview_application'

    if params[:button] == 'draft'
      draft_flash_notice!
    else
      EmployerMailer.new_job_application(current_user, job_application).deliver_later if mailing_condition
      job_application.update(state: 'applied', applied_at: Time.current)
      apply_flash_notice!
    end
    mixpanel_freelancer_application_flow_tracker
    redirect_to freelancer_applications_path
  end

  def add_work_samples
    return if params[:work_sample].blank?

    if job_application.adding_work_samples_allowed?
      job_application.work_samples.attach(params[:work_sample])
    else
      job_application.errors.add(
        :base, "Work samples limit: quantity must be #{JobApplication::MAX_WORK_SAMPLES_COUNT} or less"
      )
    end
    respond_js_format(:application_step_2)
  rescue StandardError
    job_application.errors.add(:base, 'File was not uploaded successfully.')
  end

  def destroy_work_sample
    return if find_blob_by_key.blank?

    find_blob_by_key.attachments[0].purge_later if blob_attached?
    find_blob_by_key.purge_later unless blob_attached?
    respond_js_format(:application_step_2)
  end

  private

  def draft_flash_notice!
    flash[:notice] = '<i class="far fa-check-circle"></i> <strong> Success!</strong> '\
                     "A draft was created for #{job_application.job.title.capitalize}."
  end

  def apply_flash_notice!
    flash[:notice] = '<i class="far fa-check-circle"></i> <strong> Success!</strong> '\
                     "#{job_application.job.title.capitalize} was applied for."
  end

  def mailing_condition
    job_application.applied_at.nil? || job_application.withdrawn?
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
    @application_template ||= @user.freelancer_profile
                                   .job_applications
                                   .where.not(id: job_application.id)
                                   .find_by(template: true)
  end

  def can_attach_work_sample?
    !job_application.work_samples.attached? && application_template.work_samples.attached?
  end

  def pre_populate_cover_letter_work_sample
    return if application_template.blank?

    job_application.update(cover_letter: application_template.cover_letter) if job_application.cover_letter.blank?
    if none_attached_and_template_exists?
      job_application.work_samples.attach(application_template.work_samples.map(&:blob))
    end
  end

  def none_attached_and_template_exists?
    !job_application.work_samples.attached? && application_template.work_samples.attached?
  end

  def step_2_params
    params.require(:job_application).permit(:cover_letter, :template, :job_application_id, :step)
  end

  def respond_js_format(step)
    respond_to do |format|
      format.html
      format.js do
        render step.to_s, locals:
        {
          job_application: job_application,
          job_id: params[:job_id],
          answers: @answers.presence
        }
      end
    end
  end

  def new_job_application
    @job_application ||= current_user.freelancer_profile
                                     .job_applications
                                     .build(job_id: (params[:job_id] || params[:job_application][:job_id]))
  end

  def job_application
    @job_application ||= current_user.freelancer_profile
                                     .job_applications
                                     .find_by(id: (params[:job_app] || params[:job_application][:job_application_id]))
  end

  def find_blob_by_key
    @find_blob_by_key ||= ActiveStorage::Blob.find_signed(params[:blob_key])
  rescue ActiveSupport::MessageVerifier::InvalidSignature => _e
    []
  rescue ActiveRecord::RecordNotFound => _e
    @find_blob_by_key
  end

  def blob_attached?
    return false if find_blob_by_key.blank?

    find_blob_by_key.attachments[0].present?
  end

  def mixpanel_freelancer_application_flow_tracker
    MixpanelWorker.perform_async(current_user.id, 'Apply a Job', { 'user': current_user.email,
                                                                   'job': @job_application,
                                                                   'step': step })
  end
end
