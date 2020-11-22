# frozen_string_literal: true

class Employer::BillingController < ApplicationController
  include LoggedInRedirects
  before_action :authenticate_user!, :employer_check, :check_complete_employer_profile
end
