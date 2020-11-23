# frozen_string_literal: true

class Freelancer::ApplicationsController < ApplicationController
  before_action :authenticate_user!
end
