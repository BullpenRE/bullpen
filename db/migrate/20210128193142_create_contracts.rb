class CreateContracts < ActiveRecord::Migration[6.1]
  def change
    create_table :contracts do |t|
      t.references :employer_profile, null: false, foreign_key: true
      t.references :freelancer_profile, null: false, foreign_key: true
      t.references :job, null: true, foreign_key: true
      t.string :title
      t.integer :contract_type
      t.integer :pay_rate
      t.integer :state

      t.timestamps
    end
  end
end
