class Cypress::SessionsController < ActionController::Base
  def create
    sign_in(user)
    render json: user
  end

  private

  def user
    if params[:email]
      User.find_by!(email: params.fetch(:email))
    else
      User.first!
    end
  end
end
