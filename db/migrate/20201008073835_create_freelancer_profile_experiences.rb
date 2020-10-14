class CreateFreelancerProfileExperiences < ActiveRecord::Migration[6.0]
  def change
    create_table :freelancer_profile_experiences do |t|
      t.string :job_title
      t.string :company
      t.string :location
      t.date :start_date
      t.date :end_date
      t.boolean :current_job, default: false
      t.text :description
      t.references :freelancer_profile, foreign_key: true
      t.timestamps
    end
  end
end
