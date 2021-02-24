# frozen_string_literal: true

class ConfirmationsController < Devise::ConfirmationsController
  def show
    super do |resource|
      mixpanel_confirmation_tracker
      sign_in(resource)
    end
  end

  def mixpanel_confirmation_tracker
    MixpanelWorker.perform_async(current_user.id, 'Validating account', { 'user': current_user.email })
  end
end
