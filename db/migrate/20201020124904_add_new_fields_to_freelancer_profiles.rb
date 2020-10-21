class AddNewFieldsToFreelancerProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :freelancer_profiles, :curation, :integer, default: 0
    add_column :freelancer_profiles, :is_draft, :boolean, default: true
  end
end
