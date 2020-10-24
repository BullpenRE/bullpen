class CreateSoftwares < ActiveRecord::Migration[6.0]
  def change
    create_table :softwares do |t|
      t.string :description
      t.boolean :disabled

      t.timestamps
    end
  end
end
