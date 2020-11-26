# frozen_string_literal: true

class Freelancer::JobsController < ApplicationController
  include LoggedInRedirects
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect, :incomplete_freelancer_profile_redirect

  def index
    @jobs = Job.where(state: 'posted')
  end
end
