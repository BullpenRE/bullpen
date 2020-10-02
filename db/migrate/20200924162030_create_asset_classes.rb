class CreateAssetClasses < ActiveRecord::Migration[6.0]
  def change
    create_table :asset_classes do |t|
      t.string :description, null: false
      t.boolean :disable, default: false
      t.timestamps
    end
  end
end
