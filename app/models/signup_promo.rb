# frozen_string_literal: true

class SignupPromo < ApplicationRecord
  scope :stillvalid, -> { where("expires IS NULL OR expires > ?", Time.current) }

  has_many :users

  enum user_type: {employer: 0, freelancer: 1, both: 2}
end
