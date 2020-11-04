# frozen_string_literal: true

module Promo
  class SignupPromosController < ApplicationController
    before_action :set_current_promo

    def set_current_promo
      session[:promo_code] = cookies[:promo_code]
    end

    def promo_code
      @promo_code ||= SignupPromos.find_by(session[:promo_code])
    end
  end
end
