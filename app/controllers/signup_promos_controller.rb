# frozen_string_literal: true

class SignupPromosController < ApplicationController
  before_action :session_promo

  def show
    redirect_to join_path unless promo_exist?
    session_promo
    type_user
  end

  def session_promo
    session[:promo_code] = request.fullpath.slice(7..)
  end

  def promo_exist?
    signup_promo.present?
  end

  def type_user
    return unless promo_exist?

     if signup_promo.user_type == 'employer'
       redirect_to employer_sign_up_path
     elsif signup_promo.user_type == 'freelancer'
       redirect_to freelancer_sign_up_path
     else
       redirect_to employer_sign_up_path
     end

  end

  def clear_session
    session.delete(:promo_code)
  end

  def signup_promo
    @signup_promo ||= SignupPromo.find_by(code: session[:promo_code])
  end
end
