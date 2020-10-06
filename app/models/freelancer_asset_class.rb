# frozen_string_literal: true

class FreelancerAssetClass < ApplicationRecord
  belongs_to :freelancer_profile
  belongs_to :asset_class

  validates :freelancer_profile_id, uniqueness: { scope: :asset_class_id }
end
