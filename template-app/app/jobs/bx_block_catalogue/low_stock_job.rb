module BxBlockCatalogue
  class LowStockJob < ApplicationJob
    queue_as :default

    def perform(hostname, admin, product)
      CatalogueVariantMailer.with(host: hostname).product_low_stock_notification(product, admin).deliver_now if admin.email.present?
    end

  end
end
