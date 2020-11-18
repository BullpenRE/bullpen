# frozen_string_literal: true

class Freelancer::ContractsController < ApplicationController
  before_action :authenticate_user!

end
