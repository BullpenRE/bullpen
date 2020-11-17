class CreateSignupPromo < ActiveRecord::Migration[6.0]
  def change
    create_table :signup_promos do |t|
      t.string :description
      t.string :code
      t.integer :user_type
      t.datetime :expires

      t.timestamps
    end
  end
end
