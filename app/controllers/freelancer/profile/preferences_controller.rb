# frozen_string_literal: true

module Freelancer
  module Profile
    class PreferencesController < ApplicationController
      before_action :set_freelancer_profile

      def update
        is_updated = if params[:field] == 'new_jobs_alert'
                       @freelancer_profile.update(new_jobs_alert: params[:value])
                     elsif params[:field] == 'searchable'
                       @freelancer_profile.update(searchable: params[:value])
                     else
                       false
                     end

        if is_updated
          respond_to do |format|
            format.json { render json: @freelancer_profile, status: :ok }
          end
        else
          render json: {}, status: :bad_request
        end
      end

      private

      def set_freelancer_profile
        @freelancer_profile = FreelancerProfile.find(params[:id])
      end
    end
  end
end
