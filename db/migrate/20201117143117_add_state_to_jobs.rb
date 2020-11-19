class AddStateToJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :state, :integer, default: 0
  end
end
