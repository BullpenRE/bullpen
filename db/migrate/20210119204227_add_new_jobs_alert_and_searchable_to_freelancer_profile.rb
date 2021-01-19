class AddNewJobsAlertAndSearchableToFreelancerProfile < ActiveRecord::Migration[6.0]
  def change
    add_column :freelancer_profiles, :new_jobs_alert, :boolean, default: true
    add_column :freelancer_profiles, :searchable, :boolean, default: true
  end
end
