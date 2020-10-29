class AddForeignKeyToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :signup_promos, foreign_key: true
  end
end
