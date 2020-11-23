# frozen_string_literal: true

class Freelancer::ApplicationsController < ApplicationController
  include LoggedInRedirects
  before_action :authenticate_user!, :freelancer_check, :check_accept_freelancer_profile
end
