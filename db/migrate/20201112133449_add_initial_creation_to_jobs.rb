class AddInitialCreationToJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :initial_creation, :boolean, default: true
  end
end
