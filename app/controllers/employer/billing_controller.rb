# frozen_string_literal: true

class Employer::BillingController < ApplicationController
  before_action :authenticate_user!, :initial_check, :non_employer_redirect, :incomplete_employer_profile_redirect
end
