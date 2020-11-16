# frozen_string_literal: true

class SignupPromosController < ApplicationController
  def show
    set_session_promo
    forward_to_type_of_user
  end

  def set_session_promo
    if signup_promo.present?
      session[:promo_code] = params[:promo_code]
    else
      session.delete(:promo_code)
    end
  end

  def forward_to_type_of_user
    if signup_promo.present? && signup_promo.user_type == 'employer'
      redirect_to employer_sign_up_path
    elsif signup_promo.present? &&  signup_promo.user_type == 'freelancer'
      redirect_to freelancer_sign_up_path
    else
      redirect_to join_path
    end
  end

  def signup_promo
    @signup_promo ||= SignupPromo.stillvalid.find_by(code: params[:promo_code])
  end
end
