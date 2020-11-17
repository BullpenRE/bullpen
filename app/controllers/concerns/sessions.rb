# frozen_string_literal: true

module Sessions
  def set_session_params
    return unless current_user.present?

    session[:user_id] = current_user.id
  end
end