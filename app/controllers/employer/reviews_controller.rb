# frozen_string_literal: true

class Employer::ReviewsController < ApplicationController
  include LoggedInRedirects
  before_action :authenticate_user!, :initial_check, :non_employer_redirect,
                :incomplete_employer_profile_redirect

  def save_review
    review.present? ? update_review : create_review

    redirect_to employer_contracts_path
  end

  private

  def review
    @review ||= current_user.employer_profile.reviews
                            .find_by(freelancer_profile_id: params[:review][:freelancer_profile_id])
  end

  def create_review
    @review = current_user.employer_profile.reviews.create(review_params)
    flash[:notice] = "Your review has been added for <b>#{@review.freelancer_profile.full_name}</b>.
                      Thank you for your feedback!"
    FreelancerMailer.review_was_create(@review).deliver_now
  end

  def update_review
    review.update(review_params)
    flash[:notice] = "Your review has been updated for <b>#{review.freelancer_profile.full_name}</b>.
                      Thank you for your feedback!"
    # FreelancerMailer.review_was_update(@review).deliver_now
  end

  def review_params
    params.require(:review).permit(:freelancer_profile_id, :employer_profile_id, :rating, :comments)
  end
end
