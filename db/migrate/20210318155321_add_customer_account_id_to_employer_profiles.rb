class AddCustomerAccountIdToEmployerProfiles < ActiveRecord::Migration[6.1]
  def change
    add_column :employer_profiles, :stripe_id_account, :string # for acc_ keys
    add_column :employer_profiles, :stripe_id_customer, :string # for cus_ keys
  end
end
