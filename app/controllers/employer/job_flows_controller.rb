# frozen_string_literal: true

class Employer::JobFlowsController < ApplicationController
  include Wicked::Wizard
  steps :summary, :job_type, :qualifications, :details, :questions
  before_action :authenticate_user!

  def show
    @user = current_user
    params[:start_flow].present? ? new_job : job

    respond_js_format(wizard_value(step))
  end

  def update
    @user = current_user
    params[:job][:job_id].blank? ? new_job : job

    summary_step_save ||
      job_type_save ||
      qualifications_save ||
      details_save ||
      questions_save
  end

  def summary_step_save
    return false unless params[:job][:step] == 'summary'

    job.update(summary_params)

    job.job_sectors.destroy_all
    sectors_params&.each do |sector_id|
      JobSector.create(job_id: job.id, sector_id: sector_id)
    end

    respond_js_format(:job_type)

    true
  end

  def job_type_save
    return false unless params[:job][:step] == 'job_type'

    job.update(job_type_params.merge({ 'daytime_availability_required': params['daytime_availability_required'] }))

    respond_js_format(:qualifications)

    true
  end

  def qualifications_save
    return false unless params[:job][:step] == 'qualifications'

    job.update(qualifications_params)
    save_job_skills
    save_job_softwares

    respond_js_format(:details)

    true
  end

  def details_save
    return false unless params[:job][:step] == 'details'

    job.update(relevant_job_details: params[:job][:relevant_job_details])
    respond_js_format(:questions)

    true
  end

  def questions_save
    return false unless params[:job][:step] == 'questions'

    questions_descriptions = params[:job][:job_questions].values.reject(&:empty?)
    questions_descriptions.each do |description|
      job.job_questions.create(description: description)
    end
    if params[:button] != 'draft'
      job.draft = false
      job.save
    end

    redirect_to employer_dashboard_path

    true
  end

  def destroy
    job.destroy
  end

  private

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
    params.require(:job).permit(:position_length, :hours_needed)
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
    @job ||= current_user.jobs.create
  end

  def job
    @job ||= current_user.jobs.find_by(id: (params[:job_id] || params[:job][:job_id]))
  end
end
