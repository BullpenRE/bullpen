# frozen_string_literal: true

class EmployerProfileStepsController < ApplicationController
  include Wicked::Wizard

<<<<<<< HEAD
  steps :about_company, :employee_count, :type_of_work, :sectors
=======
  steps :about_company, :employee_count, :type_of_work, :last_question
>>>>>>> master

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
<<<<<<< HEAD
      type_of_work_save || sectors_save
=======
      type_of_work_save || last_question_save
>>>>>>> master
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

    destroy_old_sectors
    sectors_params&.each do |sector|
      EmployerProfileSector.create(employer_profile_id: @employer_profile.id, sector_id: sector)
    end
    render_wizard @user

    true
  end

  def last_question_save
    return false unless wizard_value(step) == :last_question

    @employer_profile.update_attributes(last_question_params)
    render_wizard @user

    true
  end

  private

  def destroy_old_sectors
    @employer_profile&.employer_profile_sectors&.destroy_all
  end

  def company_params
    params.require(:employer_profile).permit(:company_name, :company_website, :role_in_company)
  end

  def sectors_params
    params[:employer_profile][:employer_profile_sectors]&.reject(&:blank?)
  end

  def last_question_params
    params.require(:employer_profile).permit(:motivation_one_time,
                                             :motivation_ongoing_support,
                                             :motivation_backfill,
                                             :motivation_augment,
                                             :motivation_other)
  end
end
