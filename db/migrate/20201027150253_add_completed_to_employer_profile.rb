class AddCompletedToEmployerProfile < ActiveRecord::Migration[6.0]
  def change
    add_column :employer_profiles, :completed, :boolean, default: false
  end
end
