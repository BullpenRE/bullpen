class CreateFreelancerCertifications < ActiveRecord::Migration[6.0]
  def change
    create_table :freelancer_certifications do |t|
      t.references :freelancer_profile, null: false, foreign_key: true
      t.references :certification, null: false, foreign_key: true
      t.string :description
      t.date :earned

      t.timestamps
    end
  end
end
