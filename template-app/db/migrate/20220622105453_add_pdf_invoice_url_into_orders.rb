class AddPdfInvoiceUrlIntoOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :pdf_invoice_url, :string
  end
end
