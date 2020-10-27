class CreateJobSectors < ActiveRecord::Migration[6.0]
  def change
    create_table :job_sectors do |t|
      t.references :job, null: false, foreign_key: true
      t.references :sector, null: false, foreign_key: true

      t.timestamps
    end
  end
end
