# frozen_string_literal: true

class Freelancer::JobsController < ApplicationController
  include LoggedInRedirects
  before_action :authenticate_user!, :freelancer_check, :check_accept_freelancer_profile

  def index
    @jobs = Job.where(state: 'posted')
  end
end
