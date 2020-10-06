class RenameFreelancerToFreelancerProfile < ActiveRecord::Migration[6.0]
  def up
    drop_table(:freelancer_profiles, if_exists: true)
    remove_reference :freelancer_asset_classes, :freelancers
    remove_reference :freelancer_real_estate_skills, :freelancers
    remove_reference :freelancer_real_estate_skills, :real_estate_skills
    remove_reference :freelancer_asset_classes, :asset_classes

    rename_table :freelancers, :freelancer_profiles

    add_reference :freelancer_asset_classes, :freelancer_profile
    add_reference :freelancer_real_estate_skills, :freelancer_profile
    add_reference :freelancer_real_estate_skills, :real_estate_skill
    add_reference :freelancer_asset_classes, :asset_class
  end

  def down
    remove_reference :freelancer_asset_classes, :freelancer_profile
    remove_reference :freelancer_real_estate_skills, :freelancer_profile
    remove_reference :freelancer_real_estate_skills, :real_estate_skill
    remove_reference :freelancer_asset_classes, :asset_class

    rename_table :freelancer_profiles, :freelancers

    add_reference :freelancer_asset_classes, :freelancers
    add_reference :freelancer_real_estate_skills, :freelancers
    add_reference :freelancer_real_estate_skills, :real_estate_skills
    add_reference :freelancer_asset_classes, :asset_classes
  end
end
