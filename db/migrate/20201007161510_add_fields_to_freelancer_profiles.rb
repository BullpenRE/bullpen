class AddFieldsToFreelancerProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :freelancer_profiles, :professional_title, :string
    add_column :freelancer_profiles, :professional_years_experience, :integer
    add_column :freelancer_profiles, :professional_summary, :text
  end
end
