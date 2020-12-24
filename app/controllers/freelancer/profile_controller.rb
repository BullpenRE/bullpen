# frozen_string_literal: true

class Freelancer::ProfileController < ApplicationController
  include LoggedInRedirects
  before_action :authenticate_user!, :initial_check, :non_freelancer_redirect

  def change_software_licence
    @freelancer_profile = current_user.freelancer_profile
    @freelancer_profile&.freelancer_softwares&.destroy_all
    software_params&.each do |software|
      @freelancer_profile.freelancer_softwares.create(software_id: software)
    end

    redirect_to freelancer_profile_step_path(:summary)
  end

  private

  def software_params
    params[:freelancer_softwares][:freelancer_softwares]
  end

end
