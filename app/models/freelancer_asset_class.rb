# frozen_string_literal: true

class FreelancerAssetClass < ApplicationRecord
  belongs_to :freelancer_profile, foreign_key: :freelancer_profiles_id
  belongs_to :asset_class, foreign_key: :asset_classes_id

  validates :freelancer_profiles_id, uniqueness: { scope: :asset_classes_id }
end
