# frozen_string_literal: true

# In general using helpers too much goes to a bad place. Be careful...

module ApplicationHelper
  include Pagy::Frontend

  def select_months_array
    FreelancerProfileExperience::AVAILABLE_MONTHNAMES.each_with_index.collect { |m, i| [m, i+1] }
  end

  def clean_currency_entry(currency_entry)
    currency_entry.gsub(/\$|a..zA..Z|,/, '').to_i
  end

  def separate_comma(currency)
    currency.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end
end
