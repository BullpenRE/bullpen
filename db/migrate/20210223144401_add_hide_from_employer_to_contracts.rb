class AddHideFromEmployerToContracts < ActiveRecord::Migration[6.1]
  def change
    add_column :contracts, :hide_from_employer, :boolean, default: false
  end
end
