class RenameFreelancerToFreelancerProfile < ActiveRecord::Migration[6.0]
  def up
    remove_reference :freelancer_asset_classes, :freelancers
    remove_reference :freelancer_real_estate_skills, :freelancers

    rename_table :freelancers, :freelancer_profiles

    add_reference :freelancer_asset_classes, :freelancer_profiles
    add_reference :freelancer_real_estate_skills, :freelancer_profiles
  end

  def down
    remove_reference :freelancer_asset_classes, :freelancer_profiles
    remove_reference :freelancer_real_estate_skills, :freelancer_profiles

    rename_table :freelancer_profiles, :freelancers

    add_reference :freelancer_asset_classes, :freelancers
    add_reference :freelancer_real_estate_skills, :freelancers
  end
end
