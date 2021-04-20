class AddStripeIdInvoiceToTimesheet < ActiveRecord::Migration[6.1]
  def change
    add_column :timesheets, :stripe_id_invoice, :string
    add_column :timesheets, :invoice_number, :string
    add_column :timesheets, :employer_charged_date, :datetime
  end
end
