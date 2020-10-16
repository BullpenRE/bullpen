# frozen_string_literal: true

class EmployerProfile < ApplicationRecord
  belongs_to :user

  enum category: ['Brokerage', 'Capital Markets', 'Corporate', 'Development', 'Private Equity', 'Other']
  enum available_employee_counts: %w[1-10 11-50 51-100 101+]
end
