class CreateInterviewRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :interview_requests do |t|
      t.references :employer_profile, null: false, foreign_key: true
      t.references :freelancer_profile, null: false, foreign_key: true
      t.integer :state

      t.timestamps
    end
  end
end
