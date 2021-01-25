# frozen_string_literal: true

module RequestReferer
  extend ActiveSupport::Concern

  private

  def referer_query_params
    url = URI(request.referer)
    url.query ? CGI.parse(url.query) : {}
  end
end
