class CreatePaymentAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_accounts do |t|
      t.references :employer_profile, null: false, foreign_key: true
      t.integer :stripe_object
      t.string :id_stripe
      t.string :fingerprint
      t.string :card_brand
      t.date :card_expires
      t.string :card_cvc_check
      t.string :bank_name
      t.string :bank_routing_number
      t.string :bank_status
      t.boolean :default, default: true

      t.timestamps
    end
  end
end
