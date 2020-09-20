# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable
  validates :first_name, presence: true
  validates :last_name, presence: true
end
