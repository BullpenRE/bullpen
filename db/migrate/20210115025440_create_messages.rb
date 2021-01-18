class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.bigint :from_user_id, null: false, index: true
      t.bigint :to_user_id, null: false, index: true

      t.timestamps
    end
  end
end
