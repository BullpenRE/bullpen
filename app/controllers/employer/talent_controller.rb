# frozen_string_literal: true

class Employer::TalentController < ApplicationController
  before_action :authenticate_user!

  def index
    @freelancer_profiles = FreelancerProfile.where(draft: false)
  end

end
