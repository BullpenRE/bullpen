# frozen_string_literal: true

class Freelancer::ProfileController < ApplicationController
  before_action :authenticate_user!

end
