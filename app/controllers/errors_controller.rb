class ErrorsController < ApplicationController
  def not_found
    render status: 404
  end

  def talent_not_found; end

  def job_not_found; end
end
