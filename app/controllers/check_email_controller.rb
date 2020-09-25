# frozen_string_literal: true

class CheckEmailController < ApplicationController
  skip_before_action :verify_authenticity_token

  def check_users_email
    respond_to do |format|
      format.json do
        render json: {
          same_email: User.find_by(email: params['email']).present?,
          email: params['email']
        }.to_json
      end
    end
  end
end
