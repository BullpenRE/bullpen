# frozen_string_literal: true

class EmployerProfileStepsController < ApplicationController
  include Wicked::Wizard

  before_action :step_variables, only: [:show]

  steps :about_company, :employee_count, :type_of_work, :sectors, :last_question
  before_action :authenticate_user!, :initial_check, :non_employer_redirect, :completed_profile_redirect

  def show
    @user = current_user
    if @user.employer_profile.blank?
      EmployerProfile.create(user_id: @user.id)
      @user.reload
    end
    @employer_profile = @user.employer_profile
    render_wizard
  end

  def update
    @user = current_user
    @employer_profile = @user.employer_profile
    save_current_step
    about_company_save ||
      employee_count_save ||
      type_of_work_save ||
      sectors_save ||
      last_question_save
  end

  def about_company_save
    return false unless wizard_value(step) == :about_company

    @employer_profile.update(company_params)
    mixpanel_employer_flow_tracker
    render_wizard @user

    true
  end

  def employee_count_save
    return false unless wizard_value(step) == :employee_count

    @employer_profile.update(employee_count_params)
    mixpanel_employer_flow_tracker
    render_wizard @user

    true
  end

  def type_of_work_save
    return false unless wizard_value(step) == :type_of_work

    @employer_profile.update(category: params.require(:employer_profile).values.dig(0))
    mixpanel_employer_flow_tracker
    render_wizard @user

    true
  end

  def sectors_save
    return false unless wizard_value(step) == :sectors

    destroy_old_sectors
    sectors_params&.each do |sector|
      EmployerSector.create(employer_profile_id: @employer_profile.id, sector_id: sector)
    end
    mixpanel_employer_flow_tracker
    render_wizard @user

    true
  end

  def last_question_save
    return false unless wizard_value(step) == :last_question

    @employer_profile.update(last_question_params)
    @employer_profile.completed = true
    @employer_profile.save
    mixpanel_employer_flow_tracker
    render_wizard @user

    true
  end

  def finish_wizard_path
    mixpanel_employer_flow_tracker
    employer_jobs_path
  end

  private

  def employee_count_params
    params.require(:employer_profile).permit(:employee_count)
  end

  def completed_profile_redirect
    return redirect_to employer_jobs_path(view_job: session[:view_job]) if session[:view_job].present?

    redirect_to employer_talent_index_path if current_user.employer_profile&.completed?
  end

  def step_variables
    case wizard_value(step)
    when :sectors
      sectors = Sector.enabled.order(:description)
      @sector_column1 = []
      @sector_column2 = []
      Sector.enabled.order(:description).each_with_index do |sector, index|
        index < (sectors.length / 2) ? @sector_column1 << sector : @sector_column2 << sector
      end
      @selected_sector_ids = current_user.employer_sectors.pluck(:sector_id)
    end
  end

  def destroy_old_sectors
    @employer_profile&.employer_sectors&.destroy_all
  end

  def company_params
    params.require(:employer_profile).permit(:company_name, :company_website, :role_in_company)
  end

  def sectors_params
    params[:employer_profile][:employer_sectors]&.reject(&:blank?)
  end

  def last_question_params
    params.require(:employer_profile).permit(:motivation_one_time,
                                             :motivation_ongoing_support,
                                             :motivation_backfill,
                                             :motivation_augment,
                                             :motivation_other)
  end

  def save_current_step
    @employer_profile.current_step = wizard_value(next_step)
    @employer_profile.save
  end

  def mixpanel_employer_flow_tracker
    MixpanelWorker.perform_async(current_user.id, 'Employer Steps', { 'user': current_user.email,
                                                                      'step': step })
  end
end
