# frozen_string_literal: true

module Stripe
  class RetrieveCustomerIdWorker
    include Sidekiq::Worker

    sidekiq_options retry: false

    def perform(user_id)
      Stripe::CustomerCreationService.new(user_id).call
    end
  end
end
