# frozen_string_literal: true

class Public::FreelancerProfileController < ApplicationController

  def show
    certifications
    @freelancer_profile = FreelancerProfile.lookup(params[:slug])
  end

   def request_interview
    session[:request_interview] = params[:request_interview]

    redirect_to employer_talent_index_path
  end

  private

  def certifications
    @certifications ||= Certification.enabled.pluck(:description, :id)
  end
end
