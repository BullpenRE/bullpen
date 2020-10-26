class CreateJobSoftwares < ActiveRecord::Migration[6.0]
  def change
    create_table :job_softwares do |t|
      t.references :job, null: false, foreign_key: true
      t.references :software, null: false, foreign_key: true

      t.timestamps
    end
  end
end
