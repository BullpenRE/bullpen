class RemoveUserReferenceFromJobAndJobApplication < ActiveRecord::Migration[6.1]
  def change
    remove_reference :job_applications, :user, null: false, foreign_key: true
    remove_reference :jobs, :user, null: false, foreign_key: true
  end
end
