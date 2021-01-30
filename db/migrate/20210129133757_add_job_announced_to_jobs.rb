class AddJobAnnouncedToJobs < ActiveRecord::Migration[6.1]
  def change
    add_column :jobs, :job_announced, :boolean, default: false
  end
end
