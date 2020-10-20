class AddEmployerCount < ActiveRecord::Migration[6.0]
  def change
    add_column :employer_profiles, :employee_count, :integer
  end
end
