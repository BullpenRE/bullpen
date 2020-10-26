class CreateJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :jobs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :short_description
      t.integer :position_length
      t.integer :hours_needed
      t.string :time_zone
      t.boolean :daytime_availability_required
      t.integer :required_experience
      t.string :required_regional_knowledge
      t.text :relevant_job_details
      t.boolean :draft, default: true

      t.timestamps
    end
  end
end
