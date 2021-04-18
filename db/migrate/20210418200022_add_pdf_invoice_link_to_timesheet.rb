class AddPdfInvoiceLinkToTimesheet < ActiveRecord::Migration[6.1]
  def change
    add_column :timesheets, :pdf_invoice_link, :string
  end
end
