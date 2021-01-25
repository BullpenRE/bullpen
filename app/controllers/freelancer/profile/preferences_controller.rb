# frozen_string_literal: true

module Freelancer
  module Profile
    class PreferencesController < ApplicationController
      before_action :authenticate_user!, :set_freelancer_profile

      def update
        respond_to do |format|
          if update_new_jobs_alert || update_searchable
            format.json { render json: @freelancer_profile, status: :ok }
          else
            format.json {render json: @freelancer_profile.errors, status: :unprocessable_entity }
          end
        end
      end

      private

      def set_freelancer_profile
        print "X-CSRF-Token #{request.x_csrf_token}\n"
        @freelancer_profile = current_user.freelancer_profile
      end

      def update_new_jobs_alert
        params[:field] == 'new_jobs_alert' && @freelancer_profile.update(new_jobs_alert: params[:value])
      end

      def update_searchable
        params[:field] == 'searchable' && @freelancer_profile.update(searchable: params[:value])
      end
    end
  end
end
