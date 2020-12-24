class AddColumnMessageToInterviewRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :interview_requests, :message, :text
  end
end
