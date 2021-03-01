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

    if @job_application.job.hourly?
      "Your net earnings will be <b>#{net_earnings}</b> per hour.".html_safe
    else
      hour_per_month = @job_application.job.hourly? ? '1' : @job_application.job.contract_type&.split('_')&.last
      payment_per_hour = (@job_application.bid_amount / hour_per_month.to_f) * payout_percentage

      "Your net earnings will be <b>#{net_earnings}</b> per monthfor up to #{hour_per_month} hours, plus up to
      <b>#{number_to_currency(payment_per_hour, strip_insignificant_zeros: true)}</b>
      per additional hour.".html_safe
    end
  end
end
