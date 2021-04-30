# frozen_string_literal: true

class Employer::ReviewsController < ApplicationController
  before_action :authenticate_user!, :initial_check, :non_employer_redirect,
                :incomplete_employer_profile_redirect

  def save_review
    review.present? ? update_review : create_review

    mixpanel_review_tracker('Add Review')
    redirect_to redirect_path_after_save_review
  end

  private

  def redirect_path_after_save_review
    return employer_contracts_path if params.dig(:review, :redirect_reference) == 'contracts'

    employer_jobs_path
  end

  def review
    @review ||= current_user.employer_profile.reviews
                            .find_by(freelancer_profile_id: params[:review][:freelancer_profile_id])
  end

  def create_review
    @review = current_user.employer_profile.reviews.create(review_params)
    flash[:notice] = "Your review has been added for <b>#{@review.freelancer_profile.full_name}</b>.
                      Thank you for your feedback!"
    FreelancerMailer.review_was_create(@review).deliver_later
  end

  def update_review
    review.update(review_params)
    flash[:notice] = "Your review has been updated for <b>#{review.freelancer_profile.full_name}</b>.
                      Thank you for your feedback!"
    FreelancerMailer.review_was_update(@review).deliver_later
  end

  def review_params
    params.require(:review).permit(:freelancer_profile_id, :employer_profile_id, :rating, :comments)
  end

  def mixpanel_review_tracker(action)
    MixpanelWorker.perform_async(current_user.id, action, { 'user': current_user.email })
  end
end
