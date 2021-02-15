class AddHideFromFreelancerToContracts < ActiveRecord::Migration[6.1]
  def change
    add_column :contracts, :hide_from_freelancer, :boolean, default: false
  end
end
