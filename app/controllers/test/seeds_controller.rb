# frozen_string_literal: true

module Test
  class SeedsController < ApplicationController

    skip_before_action :verify_authenticity_token

    def seed_posts
      count = params[:count] || 0

      count.to_i.times do |c|
        User.create!(
          id: c,
          email: 'new@email.com',
          password: '123'
        )
      end
    end
  end
end
