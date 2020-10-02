# frozen_string_literal: true

class AssetClass < ApplicationRecord
  validates :description, presence: true
end
