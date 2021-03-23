# frozen_string_literal: true

# Required parameters, see https://stripe.com/docs/api/customers/create


#  {
#    email: user_email@test.com,
#    name: user.full_name
#  }

module Stripe
  class CustomerCreationService
    def initialize(user)
      @user = user
      @error_message = ''
    end

    def call
      response = Stripe::Customer.create({
                                           email: @user.email,
                                           name: @user.full_name,
                                           description: @user.id
                                         })
      @error_message = response.message if response['message']
      @user.employer_profile.update(stripe_id_customer: response['id']) if response['id']
    rescue StandardError => e
      Rails.logger.info(
        "Error in CustomerCreationService impacting user id: #{@user.id}, "\
        "error details: #{e}", \
        "error_message: #{@error_message}"
      )

      { stripe_error: true }
    end
  end
end
