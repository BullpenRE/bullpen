# frozen_string_literal: true

class Public::FreelancerProfileController < ApplicationController

  def show
    @freelancer_profile = FreelancerProfile.lookup(params[:slug])
  end
end
