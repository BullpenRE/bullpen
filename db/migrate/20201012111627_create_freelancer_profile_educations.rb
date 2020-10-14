class CreateFreelancerProfileEducations < ActiveRecord::Migration[6.0]
  def change
    create_table :freelancer_profile_educations do |t|
      t.references :freelancer_profile, null: false, foreign_key: true
      t.string :institution
      t.integer :degree
      t.string :course_of_study
      t.integer :graduation_year
      t.boolean :currently_studying, default: false
      t.text :description

      t.timestamps
    end
  end
end
