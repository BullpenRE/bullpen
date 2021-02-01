class RemoveDraftFromJobs < ActiveRecord::Migration[6.0]
  def change
    remove_column :jobs, :draft
  end
end
