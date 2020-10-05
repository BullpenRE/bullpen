# frozen_string_literal: true

class EmployerRegistrationsController < RegistrationStepsController
  
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :is_employer)
  end
end
