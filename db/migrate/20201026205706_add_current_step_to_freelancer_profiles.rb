class AddCurrentStepToFreelancerProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :freelancer_profiles, :current_step, :string
  end
end
