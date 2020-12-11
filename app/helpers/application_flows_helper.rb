# frozen_string_literal: true

module ApplicationFlowsHelper
  def cleaned_per_hour_bid(per_hour_bid)
    first_el = per_hour_bid.chars.first.to_i
    end_el = per_hour_bid.chars.last.to_i

    if first_el.zero?
      cleaned_bid = per_hour_bid[1..(per_hour_bid.size - 1)]
    elsif end_el.zero? && per_hour_bid.chars.last != '0'
      cleaned_bid = per_hour_bid[0..(per_hour_bid.size - 2)]
    else
      cleaned_bid = per_hour_bid.to_i
    end
    cleaned_bid.to_i.round
  end
end
