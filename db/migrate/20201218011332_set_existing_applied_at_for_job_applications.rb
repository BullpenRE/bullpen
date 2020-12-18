class SetExistingAppliedAtForJobApplications < ActiveRecord::Migration[6.0]
  def up
    JobApplication.where(applied_at: nil, state: 'applied').each do |job_application|
      job_application.update(applied_at: job_application.updated_at)
    end
  end
end
