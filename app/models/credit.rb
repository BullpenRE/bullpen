# frozen_string_literal: true

class Credit < ApplicationRecord
  belongs_to :timesheet
  enum applied_to: { 'employer': 0, 'freelancer': 1 }
end
