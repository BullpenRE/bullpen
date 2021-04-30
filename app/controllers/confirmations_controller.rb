# frozen_string_literal: true

class ConfirmationsController < Devise::ConfirmationsController
  def show
    super do |resource|
      mixpanel_confirmation_tracker
      sign_in(resource)
    end
  end

  def mixpanel_confirmation_tracker
    MixpanelWorker.perform_async(@user.id, 'Validating account', { 'user': @user.email, 'role': @user.role })
  end
end
