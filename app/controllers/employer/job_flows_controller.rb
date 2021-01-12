# frozen_string_literal: true

class Employer::JobFlowsController < ApplicationController
  include Wicked::Wizard
  include LoggedInRedirects
  include ApplicationHelper
  steps :post_job_step_1, :post_job_step_2, :post_job_step_3, :post_job_step_4, :post_job_step_5, :preview_job
  before_action :authenticate_user!, :initial_check

  def show
    @user = current_user
    @available_time_zones = Job.time_zones
    params[:start_flow].present? ? new_job : job

    respond_js_format(wizard_value(step))
  end

  def update
    @user = current_user
    @available_time_zones = Job.time_zones
    params[:job][:job_id].blank? ? new_job : job
    @time_zone = job.time_zone

    summary_step_save ||
      job_type_save ||
      qualifications_save ||
      details_save ||
      questions_save ||
      preview_job_save
  end

  def summary_step_save
    return false unless params[:job][:step] == 'post_job_step_1'

    job.update(summary_params)

    job.job_sectors.destroy_all
    sectors_params&.each do |sector_id|
      JobSector.create(job_id: job.id, sector_id: sector_id)
    end

    respond_js_format(:post_job_step_2)

    true
  end

  def job_type_save
    return false unless params[:job][:step] == 'post_job_step_2'

    job.update(job_type_params.merge({ 'daytime_availability_required': params['daytime_availability_required'] }))

    respond_js_format(:post_job_step_3)

    true
  end

  def qualifications_save
    return false unless params[:job][:step] == 'post_job_step_3'

    job.update(qualifications_params)
    save_job_skills
    save_job_softwares

    respond_js_format(:post_job_step_4)

    true
  end

  def details_save
    return false unless params[:job][:step] == 'post_job_step_4'

    job.update(details_params.merge(relevant_job_details: params[:job][:relevant_job_details]))
    respond_js_format(:post_job_step_5)

    true
  end

  def questions_save
    return false unless params[:job][:step] == 'post_job_step_5'

    questions_descriptions = params[:job][:job_questions].values.reject(&:empty?)
    job.job_questions.destroy_all if job.job_questions.any?
    questions_descriptions.each do |description|
      job.job_questions.create(description: description)
    end
    job.update(initial_creation: false)
    if params[:button] == 'draft'
      job.update(state: 'draft')
      redirect_to employer_jobs_path
    else
      respond_js_format(:preview_job)
    end

    true
  end

  def preview_job_save
    return false unless params[:job][:step] == 'preview_job'

    params[:button] != 'draft' ? job.update(state: 'posted') : job.update(state: 'draft')

    redirect_to employer_jobs_path

    true
  end

  private

  def details_params
    if params[:job][:contract_type] == 'hourly'
      {
        contract_type: params[:job][:contract_type],
        pay_range_low: clean_currency_entry(params[:job][:pay_range_low]),
        pay_range_high: pay_range_high
      }
    else
      {
        contract_type: params[:job][:contract_type],
        pay_range_low: clean_currency_entry(params[:job][:pay_range_low]),
        pay_range_high: nil
      }
    end
  end

  def pay_range_high
    params[:job][:pay_range_high].present? ? clean_currency_entry(params[:job][:pay_range_high]) : nil
  end

  def save_job_skills
    job.job_skills.destroy_all
    skills_params&.each do |skill|
      JobSkill.create(job_id: job.id, skill_id: skill)
    end
  end

  def save_job_softwares
    job.job_softwares.destroy_all
    softwares_params&.each do |soft|
      JobSoftware.create(job_id: job.id, software_id: soft)
    end
  end

  def skills_params
    params[:job][:job_skills]&.reject(&:blank?)
  end

  def softwares_params
    params[:job][:job_softwares]&.reject(&:blank?)
  end

  def summary_params
    params.require(:job).permit(:title, :short_description)
  end

  def sectors_params
    params[:job][:job_sectors]&.reject(&:blank?)
  end

  def job_type_params
    params.require(:job).permit(:position_length, :hours_needed, :time_zone)
  end

  def qualifications_params
    params.require(:job).permit(:required_experience, :required_regional_knowledge)
  end

  def respond_js_format(step)
    respond_to do |format|
      format.html
      format.js { render step.to_s, locals: { job: job } }
    end
  end

  def new_job
    @job ||= current_user.jobs.build
  end

  def job
    @job ||= current_user.jobs.find_by(id: (params[:job_id] || params[:job][:job_id]))
  end
end
