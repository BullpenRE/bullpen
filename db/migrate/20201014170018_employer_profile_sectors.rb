class EmployerProfileSectors < ActiveRecord::Migration[6.0]
  def change
    create_table :employer_profile_sectors do |t|
      t.string :description, null: false
      t.boolean :disable, default: false
      t.timestamps
    end
  end
end
