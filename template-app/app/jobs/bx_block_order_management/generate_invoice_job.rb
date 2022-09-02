module BxBlockOrderManagement
  class GenerateInvoiceJob < ApplicationJob
    queue_as :default

    def perform(order_id)
      order = BxBlockOrderManagement::Order.find_by(id: order_id)
      order.upload_invoice_to_s3 if order.present?
    end

  end
end
