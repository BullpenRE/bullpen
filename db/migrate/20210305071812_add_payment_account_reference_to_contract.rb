class AddPaymentAccountReferenceToContract < ActiveRecord::Migration[6.1]
  def change
    add_reference :contracts, :payment_account, null: true, foreign_key: true
  end
end
