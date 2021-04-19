class CreateCredits < ActiveRecord::Migration[6.1]
  def change
    create_table :credits do |t|
      t.references :timesheet, index: true, foreign_key: true
      t.integer :applied_to, default: 0
      t.string :description
      t.integer :amount

      t.timestamps
    end
  end
end
