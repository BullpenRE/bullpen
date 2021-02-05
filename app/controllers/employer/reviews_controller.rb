# frozen_string_literal: true

class Employer::ReviewsController < ApplicationController
  include LoggedInRedirects
  before_action :authenticate_user!, :initial_check, :non_employer_redirect,
                :incomplete_employer_profile_redirect

  def create
    @review = current_user.employer_profile.reviews.create(review_params)
    flash[:notice] = "Your review has been added for <b>#{@review.freelancer_profile.full_name}</b>.
                      Thank you for your feedback!"
    FreelancerMailer.review_was_create(@review).deliver_now

    redirect_to employer_contracts_path
  end

  private

  def review_params
    params.require(:review).permit(:freelancer_profile_id, :employer_profile_id, :rating, :comments)
  end
end
