# frozen_string_literal: true

class EmployerProfile < ApplicationRecord
  belongs_to :user

  enum available_employee_counts: %w[1-10 11-50 51-100 101+]
  enum category: {
    'Brokerage': 0,
    'Capital Markets': 1,
    'Corporate': 2,
    'Development': 3,
    'Private Equity': 4,
    'Other': 5
  }
end
