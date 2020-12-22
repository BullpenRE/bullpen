class AddAppliedAtDateToJobApplication < ActiveRecord::Migration[6.0]
  def change
    add_column :job_applications, :applied_at, :datetime, precision: 6
  end
end
