# frozen_string_literal: true

class SignupPromoController < ApplicationController
  def show
    session_promo
    promo_exist?
    type_user
    #clear_session
  end

  def session_promo
    session[:code] = request.fullpath.slice(7..)
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
    session.delete(:code)
  end

  def signup_promo
    SignupPromos.find_by(code: session[:code])
  end
end
