# frozen_string_literal: true

class RealEstateSkill < ApplicationRecord
  validates :description, presence: true
end
