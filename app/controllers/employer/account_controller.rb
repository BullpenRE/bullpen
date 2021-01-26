# frozen_string_literal: true

module Employer
  class AccountController < ApplicationController
    before_action :authenticate_user!

    def index
      employer_profile
    end

    private

    def employer_profile
      @employer_profile ||= current_user.employer_profile
    end
  end
end

