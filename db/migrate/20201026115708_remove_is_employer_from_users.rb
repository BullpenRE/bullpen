class RemoveIsEmployerFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :is_employer, :boolean
  end
end
