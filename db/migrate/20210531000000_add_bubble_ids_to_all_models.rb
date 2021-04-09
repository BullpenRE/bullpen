class AddBubbleIdsToAllModels < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :id_bubble, :string
    add_column :freelancer_profiles, :id_bubble, :string
    add_column :employer_profiles, :id_bubble, :string
    add_column :contracts, :id_bubble, :string
  end
end
