class SetStateForExistingJobs < ActiveRecord::Migration[6.0]
  def up
    Job.where(draft: true).update_all(state: Job.states['draft'])
    Job.where.not(draft: true).update_all(state: Job.states['posted'])
  end
end
