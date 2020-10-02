class FreelancerAssetClass < ApplicationRecord
  validates :freelancers_id, uniqueness: { scope: :asset_classes_id }
end
