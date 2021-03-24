class CreateBillings < ActiveRecord::Migration[6.1]
  def change
    create_table :billings do |t|
      t.references :contract, null: false, foreign_key: true
      t.date :work_done
      t.integer :hours
      t.integer :minutes
      t.string :description
      t.integer :state, default: 0
      t.string :dispute_comments
      t.date :dispute_resolved

      t.timestamps
    end
  end
end
