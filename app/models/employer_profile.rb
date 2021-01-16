# frozen_string_literal: true

class EmployerProfile < ApplicationRecord
  belongs_to :user
  has_many :employer_sectors, dependent: :destroy
  has_many :sectors, through: :employer_sectors
  has_many :interview_requests, dependent: :destroy

  enum employee_count: { '1-10': 0, '11-50': 1, '51-100': 2, '101+': 3 }
  enum category: {
    'Brokerage': 0,
    'Capital Markets': 1,
    'Corporate': 2,
    'Development': 3,
    'Private Equity': 4,
    'Other': 5
  }

  def email
    @email ||= user.email
  end

  def full_name
    @full_name ||= user.full_name
  end
end
