class CreateSectors < ActiveRecord::Migration[6.0]
  def change
    create_table :sectors do |t|
      t.string :description
      t.boolean :disabled, default: false

      t.timestamps
    end
  end
end
