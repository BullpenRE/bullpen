class RenameDefaultAttributeInPaymentAccounts < ActiveRecord::Migration[6.1]
  def change
    rename_column :payment_accounts, :default, :is_default
  end
end
