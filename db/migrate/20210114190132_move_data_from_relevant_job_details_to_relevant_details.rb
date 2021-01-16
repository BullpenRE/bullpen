class MoveDataFromRelevantJobDetailsToRelevantDetails < ActiveRecord::Migration[6.0]
  def up
    Job.all.each do |job|
      job.update(relevant_details: job.relevant_job_details)
    end
  end
end
