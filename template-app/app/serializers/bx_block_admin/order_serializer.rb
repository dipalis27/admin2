module BxBlockAdmin
  class OrderSerializer < BuilderBase::BaseSerializer
    attributes :id, :order_number, :status, :total, :sub_total, :total_tax, :shipping_charge, :applied_discount, :pdf_invoice_url

    attribute :order_date do |object|
      object.order_date.strftime("%b %d %Y, %I:%M %p") rescue ''
    end

    attribute :coupon_code do |object|
      if object.coupon_code
        object.coupon_code.code
      end
    end

    attribute :order_items do |object, params|
      if params[:order_items].present? && object.order_items.present?
        BxBlockAdmin::OrderItemSerializer.new(object.order_items)
      end
    end

    attribute :delivery_addresses do |object, params|
      if params[:delivery_addresses].present? && object.delivery_addresses.present?
        BxBlockAdmin::DeliveryAddressSerializer.new(object.delivery_addresses)
      end
    end

    attribute :account do |object|
      BxBlockAdmin::AccountSerializer.new(object.account)
    end
  end
end