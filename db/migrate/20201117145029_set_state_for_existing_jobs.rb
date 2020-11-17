class SetStateForExistingJobs < ActiveRecord::Migration[6.0]
  def up
    Job.all.each do |job|
      job.draft == true ? job.update!(state: 0) : job.update!(state: 1)
    end
  end
end
