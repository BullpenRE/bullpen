class AddNewFieldsToFreelancerProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :freelancer_profiles, :is_declined, :boolean
    add_column :freelancer_profiles, :is_pending, :boolean, default: true
    add_column :freelancer_profiles, :is_accepted, :boolean
    add_column :freelancer_profiles, :is_draft, :boolean, default: true
  end
end
