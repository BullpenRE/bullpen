# frozen_string_literal: true

class EmployerProfile < ApplicationRecord
  belongs_to :user

  validates :company_name, presence: true
  validates :company_website, presence: true
  validates :role_in_company, presence: true
end
