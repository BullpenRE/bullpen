# frozen_string_literal: true

class JobApplicationPresenter
  include ActionView::Helpers

  def initialize(job_application)
    @job_application = job_application
  end

  def net_earnings
    return if @job_application.bid_amount.blank?

    if @job_application.job.hourly?
      "Your net earnings will be <b>#{number_to_currency(@job_application.bid_amount*0.7)}</b> per hour.".html_safe
    else
      hour_per_month = @job_application.job.hourly? ? '1' : @job_application.job.contract_type&.split('_')&.last
      "Your net earnings will be <b>#{number_to_currency(@job_application.bid_amount*0.7)}</b> per month for up to #{hour_per_month} hours, plus up to <b>#{number_to_currency((@job_application.bid_amount/hour_per_month.to_i)*0.7)}</b> per additional hour.".html_safe
    end
  end
end