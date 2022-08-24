# == Schema Information
#
# Table name: order_items
#
#  id                      :bigint           not null, primary key
#  order_id                :bigint           not null
#  quantity                :integer
#  unit_price              :decimal(, )
#  total_price             :decimal(, )
#  old_unit_price          :decimal(, )
#  status                  :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  catalogue_id            :bigint           not null
#  catalogue_variant_id    :bigint           not null
#  order_status_id         :integer
#  placed_at               :datetime
#  confirmed_at            :datetime
#  in_transit_at           :datetime
#  delivered_at            :datetime
#  cancelled_at            :datetime
#  refunded_at             :datetime
#  manage_placed_status    :boolean          default(FALSE)
#  manage_cancelled_status :boolean          default(FALSE)
#
module BxBlockOrderManagement
  class OrderItemSerializer < BuilderBase::BaseSerializer

    # belongs_to :order, serializer: OrderSerializer, if: Proc.new { |rec, params| params[:order].present? }
    # belongs_to :catalogue, serializer: BxBlockCatalogue::CatalogueSerializer, if: Proc.new { |rec, params| params[:my_orders].blank? }
    # belongs_to :catalogue_variant, serializer: BxBlockCatalogue::CatalogueVariantSerializer

    attributes *[
      :id,
      :order_id,
      :quantity,
      :unit_price,
      :total_price,
      :old_unit_price,
      :status,
      :catalogue_id,
      :catalogue_variant_id,
      :order_status_id,
      :placed_at,
      :confirmed_at,
      :in_transit_at,
      :delivered_at,
      :cancelled_at,
      :refunded_at,
      :manage_placed_status,
      :manage_cancelled_status,
      :created_at,
      :updated_at,
      :subscription_quantity,
      :subscription_package,
      :subscription_period,
      :subscription_discount,
      :preferred_delivery_slot
    ]

    attribute :subscription_days_count do |object|
      if object.subscription_quantity.present?
        order_item = object
        item_count = ((Date.tomorrow + order_item.subscription_period.to_i.months) - Date.tomorrow).to_i
        if order_item.subscription_package.to_s.downcase == 'daily'
          order_item_quantity = item_count * order_item.subscription_quantity
        elsif order_item.subscription_package.to_s.downcase == 'weekly'
          order_item_quantity = (item_count / 7 ) * order_item.subscription_quantity
        elsif order_item.subscription_package.to_s.downcase == 'monthly'
          order_item_quantity = order_item.subscription_period.to_i * order_item.subscription_quantity
        end
      else
        nil
      end
    end

    attribute :order, if: Proc.new { |rec,params| params[:order].present? }
    attribute :order_statuses do |object, params|
      if params.present?
        order = object.order
        {
          order_number: order.order_number,
          placed_at: order.placed_at,
          confirmed_at: order.confirmed_at,
          in_transit_at: order.in_transit_at,
          delivered_at: order.delivered_at,
          cancelled_at: order.cancelled_at,
          refunded_at: order.refunded_at,
        }
      end
    end

    attribute :delivery_addresses do |object,params|
      if Proc.new { |rec,params| params[:order] } && object.present?
        object.order&.delivery_addresses
      end
    end

    attribute :catalogue do |object, params|
      if object.present? && Proc.new { |rec,params| params[:my_orders].blank? }
        BxBlockCatalogue::CatalogueSerializer.new(object.catalogue, { params: params }).serializable_hash[:data]
      end
    end

    attribute :catalogue_variant do |object, params|
      if object.present?
        BxBlockCatalogue::CatalogueVariantSerializer.new(object.catalogue_variant, { params: params } ).serializable_hash[:data]
      end
    end

    attribute :product_name do |object|
      object&.catalogue&.name
    end

    attribute :overall_order_status do |object|
      object&.order&.status
    end

    attribute :product_price do |object|
      object&.catalogue&.price
    end

    attribute :product_sale_price do |object|
      object&.catalogue&.sale_price
    end

    attribute :product_on_sale do |object|
      object&.catalogue&.on_sale
    end

    attribute :product_discount do |object|
      object&.catalogue&.discount
    end

    attribute :product_variant_price do |object|
      object&.catalogue_variant&.price
    end

    attribute :product_variant_sale_price do |object|
      object&.catalogue_variant&.sale_price
    end

    attribute :product_variant_on_sale do |object|
      object&.catalogue_variant&.on_sale
    end

    attribute :product_variant_discount do |object|
      object&.catalogue_variant&.discount_price
    end

    attribute :product_variant_is_deliverable do |object|
      object&.catalogue_variant&.present? && object&.catalogue_variant&.stock_qty&.positive?
    end

    attribute :is_item_cancelled do |object|
      object&.cancelled?
    end

    attribute :is_review_present do |object|
      object.review.present? ? true : false
    end

    attribute :review do |object|
      review = object.review
      {id:review&.id, comment:review&.comment, rating:review&.rating } if review.present?
    end

    attribute :delivery_address do |object|
      if object.order.delivery_address_orders.present?
        delivery_address_order = object.order.delivery_address_orders.joins(:delivery_address).where("delivery_addresses.address_for IN (?) ", ['shipping','billing_and_shipping']).last
        delivery_address_order&.delivery_address if delivery_address_order.present?
      end
    end

    attribute :order_date do |object, params|
      object.order.order_date&.in_time_zone(Order::TIME_ZONE)&.strftime("%a, #{object.order.order_date&.day.ordinalize} %B %Y") if Proc.new { |rec,params| params[:order_date] }
    end

    attribute :order_number do |object, params|
      object.order.order_number if Proc.new { |rec,params| params[:order_number] }
    end

    attribute :is_deliverable do |object, params|
      object.catalogue.present? && object.catalogue&.stock_qty&.positive? if Proc.new { |rec,params| params[:current_user] && params[:my_orders].blank? }
    end

    attribute :product_images do |object, params|
      if params[:my_orders] && object&.catalogue&.attachments&.present?
        BxBlockFileUpload::AttachmentSerializer.new(object&.catalogue&.attachments, { params: params })
      end
    end

    attribute :item_history do |object, params|
      if Proc.new { |rec,params| params[:show_history] }
        a = []
        object.trackings.order(updated_at: :desc).each do |t|
          a<< { status: t.status.to_s.titleize, order_date: t.date&.in_time_zone(Order::TIME_ZONE)&.strftime("%a, #{t.date&.in_time_zone(Order::TIME_ZONE).day.ordinalize} %B '%y"), order_datetime: t.date&.in_time_zone(Order::TIME_ZONE)&.strftime("%a, #{t.date&.in_time_zone(Order::TIME_ZONE).day.ordinalize} %B '%Y - %I:%M %p"), msg: "Your order has been #{t.status.to_s.titleize}",
          tracking_number: t.tracking_number
        }
        end
        a
      end
    end
  end
end
