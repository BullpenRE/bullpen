class UpdateJobAnnouncedToExistingJobs < ActiveRecord::Migration[6.1]
  def up
    Job.update_all(job_announced: true)
  end
end
