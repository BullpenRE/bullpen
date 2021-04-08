class AddEmployerNotifiedOfFreelancerChangesToTimesheet < ActiveRecord::Migration[6.1]
  def change
    add_column :timesheets, :employer_notified_of_freelancer_changes, :boolean, default: true
  end
end
