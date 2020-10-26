class CreateEmployerSectors < ActiveRecord::Migration[6.0]
  def change
    create_table :employer_sectors do |t|
      t.references :sector, null: false, foreign_key: true
      t.references :employer_profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
