# frozen_string_literal: true

class EmployerProfileStepsController < ApplicationController
  include Wicked::Wizard

  steps :about_company, :employee_count, :type_of_work, :sectors

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

    about_company_save ||
      employee_count_save ||
      type_of_work_save || sectors_save
  end

  def about_company_save
    return false unless wizard_value(step) == :about_company

    @employer_profile.update_attributes(company_params)
    render_wizard @user

    true
  end

  def employee_count_save
    return false unless wizard_value(step) == :employee_count

    @employer_profile.update(employee_count: params.require(:employer_profile).values.dig(0))
    render_wizard @user

    true
  end

  def type_of_work_save
    return false unless wizard_value(step) == :type_of_work

    @employer_profile.update(category: params.require(:employer_profile).values.dig(0))
    render_wizard @user

    true
  end

  def sectors_save
    return false unless wizard_value(step) == :sectors

    sectors_params&.each do |sector|
      EmployerProfileSector.create(employer_profile_id: @employer_profile.id, sector_id: sector)
    end
    render_wizard @user

    true
  end

  def company_params
    params.require(:employer_profile).permit(:company_name, :company_website, :role_in_company)
  end

  def sectors_params
    params[:employer_profile][:employer_profile_sectors]&.reject(&:blank?)
  end
end
