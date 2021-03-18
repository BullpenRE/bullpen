class AddCustomerAccountIdToEmployerProfiles < ActiveRecord::Migration[6.1]
  def change
    add_column :employer_profiles, :stripe_customer_id_account, :string
  end
end
