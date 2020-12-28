class RemoveColumnMessageFromInterviewRequests < ActiveRecord::Migration[6.0]
  def change
    remove_column :interview_requests, :message, :text
  end
end
