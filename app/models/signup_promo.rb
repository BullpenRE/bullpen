# frozen_string_literal: true

class SignupPromo < ApplicationRecord
  has_many :users

  enum user_type: {employer: 0, freelancer: 1, both: 2}
end
