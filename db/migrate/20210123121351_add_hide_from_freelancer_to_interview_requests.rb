class AddHideFromFreelancerToInterviewRequests < ActiveRecord::Migration[6.0]
  def change
     add_column :interview_requests, :hide_from_freelancer, :boolean, default: false
  end
end
