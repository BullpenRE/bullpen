# frozen_string_literal: true

class Employer::JobsController < ApplicationController
  include Wicked::Wizard
  steps :summary, :job_type, :qualifications, :details
  before_action :authenticate_user!

  def show
    @user = current_user
    @job = params[:start_flow].present? ? current_user.jobs.create : current_user.jobs.find_by(id: params[:job_id])

    respond_to do |format|
      format.html
      format.js { render wizard_value(step), locals: { job: @job } }
    end
  end

  def update
    @user = current_user

    summary_step_save ||
      job_type_save ||
      qualifications_save
  end

  def summary_step_save
    return false unless params[:job][:step] == 'summary'

    @job = params[:job][:job_id].blank? ? Job.create(user_id: @user.id) : Job.find_by(id: params[:job][:job_id])
    @job.update(summary_params)

    @job.job_sectors.destroy_all
    sectors_params&.each do |sector|
      JobSector.create(job_id: @job.id, sector_id: sector)
    end

    respond_js_format(:job_type)

    true
  end

  def job_type_save
    return false unless params[:job][:step] == 'job_type'

    @job = find_job
    @job.update(job_type_params)
    @job.update(daytime_availability_required: params[:daytime_availability_required])

    respond_js_format(:qualifications)

    true
  end

  def qualifications_save
    return false unless params[:job][:step] == 'qualifications'

    @job = find_job
    @job.update(qualifications_params)
    save_job_skills_softwares

    respond_js_format(:details)

    true
  end

  private

  def save_job_skills_softwares
    @job.job_skills.destroy_all
    @job.job_softwares.destroy_all
    skills_params&.each do |skill|
      JobSkill.create(job_id: @job.id, skill_id: skill)
    end
    softwares_params&.each do |soft|
      JobSoftware.create(job_id: @job.id, software_id: soft)
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
      format.js { render step.to_s, locals: { job: @job } }
    end
  end

  def find_job
    @user.jobs.find_by(id: params[:job][:job_id])
  end
end