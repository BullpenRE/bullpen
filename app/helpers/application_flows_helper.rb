# frozen_string_literal: true

module ApplicationFlowsHelper
  def cleaned_per_hour_bid(per_hour_bid)
    per_hour_bid.gsub(/\$|a..zA..Z|,/, '').to_i
  end
end
