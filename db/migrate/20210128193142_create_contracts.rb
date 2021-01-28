class CreateContracts < ActiveRecord::Migration[6.1]
  def change
    create_table :contracts do |t|
      t.references :from_user, null: false, foreign_key: { to_table: :users }
      t.references :to_user, null: false, foreign_key: { to_table: :users }
      t.bigint :job_id, null: true, index: true
      t.string :title
      t.string :short_description
      t.integer :contract_type
      t.integer :pay_rate
      t.integer :state

      t.timestamps
    end
  end
end
