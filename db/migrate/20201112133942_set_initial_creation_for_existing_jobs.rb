class SetInitialCreationForExistingJobs < ActiveRecord::Migration[6.0]
  def up
    Job.update_all(initial_creation: false)
  end
end
