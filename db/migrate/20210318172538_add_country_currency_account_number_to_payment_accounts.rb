class AddCountryCurrencyAccountNumberToPaymentAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :payment_accounts, :country, :string
    add_column :payment_accounts, :currency, :string
    add_column :payment_accounts, :bank_account_number, :string
  end
end
