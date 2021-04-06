# frozen_string_literal: true

class JobApplicationPresenter
  include ActionView::Helpers

  def initialize(job_application)
    @job_application = job_application
  end

  def net_earnings
    return if @job_application.bid_amount.blank?

    payout_percentage = (@job_application.freelancer_profile.payout_percentage || 70) / 100.0
    net_earnings = number_to_currency(@job_application.bid_amount * payout_percentage, strip_insignificant_zeros: true)

    "Your net earnings will be <b>#{net_earnings}</b> per hour.".html_safe
  end
end
