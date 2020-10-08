# frozen_string_literal: true

class EmployerProfileStepsController < ApplicationController
  include Wicked::Wizard

  steps :about_company

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

  end

  def about_company

  end

  def company_params
    params.require(:employer_profile).permit(:company_name, :company_website, :role_in_company)
  end
end
