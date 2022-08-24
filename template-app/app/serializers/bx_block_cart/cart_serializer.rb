module BxBlockCart
  class CartSerializer < BuilderBase::BaseSerializer

    # belongs_to :account, serializer: AccountBlock::AccountSerializer,
    #   if: Proc.new {|rec, params| params[:user].present? }
    # has_many :order_items, serializer: BxBlockOrderManagement::OrderItemSerializer
    # has_many :delivery_addresses, serializer: AddressesSerializer

    attributes *[
        :id,
        :order_number,
        :amount,
        :account_id,
        :coupon_code_id,
        :delivery_address_id,
        :sub_total,
        :total,
        :status,
        :applied_discount,
        :cancellation_reason,
        :order_date,
        :is_gift,
        :placed_at,
        :confirmed_at,
        :in_transit_at,
        :delivered_at,
        :cancelled_at,
        :refunded_at,
        :source,
        :shipment_id,
        :delivery_charges,
        :tracking_url,
        :schedule_time,
        :payment_failed_at,
        :payment_pending_at,
        :returned_at,
        :tax_charges,
        :deliver_by,
        :tracking_number,
        :is_error,
        :delivery_error_message,
        :order_status_id,
        :is_group,
        :is_availability_checked,
        :shipping_charge,
        :shipping_discount,
        :shipping_net_amt,
        :shipping_total,
        :total_tax,
        :created_at,
        :updated_at,
        :delivery_addresses,
        :razorpay_order_id
    ]

    attribute :order_items do |object, params|
      if object.present?
        BxBlockOrderManagement::OrderItemSerializer.new(
          object.order_items.latest_first, { params: params }
        ).serializable_hash[:data]
      end
    end

    attribute :account do |object|
      if object.present?
        AccountBlock::AccountSerializer.new(object.account).serializable_hash[:data]
      end
    end

    attribute :order_transaction do |object|
      if object.present?
        object.order_transactions
      end
    end

    attribute :coupon do |object|
      if object.present?
        BxBlockCouponCodeGenerator::CouponCodeSerializer.new(object.coupon_code).serializable_hash[:data]
      end
    end

    attribute :total do |object|
      object.total&.round(2)
    end
  end
end
