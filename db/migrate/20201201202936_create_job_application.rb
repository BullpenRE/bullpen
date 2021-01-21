class CreateJobApplication < ActiveRecord::Migration[6.0]
  def change
    create_table :job_applications do |t|
      t.references :job, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.text :cover_letter
      t.boolean :template, default: false
      t.integer :bid_amount
      t.boolean :available_during_work_hours
      t.integer :state

      t.timestamps
    end
  end
end
