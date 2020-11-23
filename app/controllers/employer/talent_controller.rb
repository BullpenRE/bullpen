# frozen_string_literal: true

class Employer::TalentController < ApplicationController
  include LoggedInRedirects
  before_action :authenticate_user!, :initial_check, :non_employer_redirect, :incomplete_employer_profile_redirect
end
