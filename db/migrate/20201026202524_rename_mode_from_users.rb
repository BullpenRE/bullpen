class RenameModeFromUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :mode, :role
  end
end
