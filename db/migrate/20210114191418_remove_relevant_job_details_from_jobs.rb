class RemoveRelevantJobDetailsFromJobs < ActiveRecord::Migration[6.0]
  def change
    remove_column :jobs, :relevant_job_details, :text
  end
end
