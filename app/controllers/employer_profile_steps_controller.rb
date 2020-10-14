# frozen_string_literal: true

class EmployerProfileStepsController < ApplicationController
  include Wicked::Wizard

  AVAILABLE_EMPLOYEE_COUNT = %w['1-10', '11-50', '51-100', '101+']

  steps :about_company, :employee_count

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

    about_company_save if wizard_value(step) == :about_company
    employee_count_save if wizard_value(step) == :employee_count

    render_wizard @user
  end

  def about_company_save
    @employer_profile.update_attributes(company_params)
  end

  def employee_count_save

  end

  def company_params
    params.require(:employer_profile).permit(:company_name, :company_website, :role_in_company)
  end
end
