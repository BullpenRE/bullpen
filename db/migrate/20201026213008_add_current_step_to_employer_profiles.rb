class AddCurrentStepToEmployerProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :employer_profiles, :current_step, :string
  end
end
