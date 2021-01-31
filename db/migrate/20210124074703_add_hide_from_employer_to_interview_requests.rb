class AddHideFromEmployerToInterviewRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :interview_requests, :hide_from_employer, :boolean, default: false
  end
end
