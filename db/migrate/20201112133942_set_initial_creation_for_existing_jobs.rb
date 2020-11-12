class SetInitialCreationForExistingJobs < ActiveRecord::Migration[6.0]
  def up
    Job.update_all(initial_creation: false)
  end

  def down
    Job.update_all(initial_creation: true)
  end
end
