# frozen_string_literal: true

class AssetClass < ApplicationRecord
  validates :description, presence: true, uniqueness: true
  has_many :freelancer_asset_classes, dependent: :destroy
  has_many :freelancer_profiles, through: :freelancer_asset_classes
end
