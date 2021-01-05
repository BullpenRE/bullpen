# frozen_string_literal: true

class Public::JobController < ApplicationController

  def show
    @job = Job.lookup(params[:slug])
  end
end
