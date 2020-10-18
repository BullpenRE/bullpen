class AddCategoryField < ActiveRecord::Migration[6.0]
  def change
    add_column :employer_profiles, :category, :integer
  end
end
