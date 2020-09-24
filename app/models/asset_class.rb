class AssetClass < ApplicationRecord
  validates :description, presence: true
end
