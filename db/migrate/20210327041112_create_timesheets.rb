class CreateTimesheets < ActiveRecord::Migration[6.1]
  def change
    create_table :timesheets do |t|
      t.references :contract, null: false, foreign_key: true
      t.string :description
      t.date :starts
      t.date :ends

      t.timestamps
    end

    add_reference :billings, :timesheet, null: true, foreign_key: true
  end
end
