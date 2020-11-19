# frozen_string_literal: true

class Freelancer::JobsController < ApplicationController
  before_action :authenticate_user!

  def index
    @jobs = Job.where(state: 'posted')
  end
end
