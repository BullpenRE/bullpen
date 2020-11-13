class AddForeignKeyToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :signup_promo, foreign_key: true
  end
end
