
# == Schema Information
#
# Table name: catalogue
#
#  id                   :bigint           not null, primary key
#  category_id          :bigint           not null
#  sub_category_id      :bigint           not null
#  brand_id             :bigint
#  name                 :string
#  sku                  :string
#  description          :string
#  manufacture_date     :datetime
#  length               :float
#  breadth              :float
#  height               :float
#  availability         :integer
#  stock_qty            :integer
#  weight               :decimal(, )
#  price                :float
#  recommended          :boolean
#  on_sale              :boolean
#  sale_price           :decimal(, )
#  discount             :decimal(, )
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  block_qty            :integer
#  sold                 :integer          default(0)
#  available_price      :float
#  status               :integer
#  tax_amount           :decimal
#  price_including_tax  :decimal
#  trending             :boolean          default => false

module BxBlockAdmin
  class CatalogueSerializer < BuilderBase::BaseSerializer
    extend AttachmentHelper

    attributes :id, :name, :sku, :description, :manufacture_date, :length, :breadth, :height, :availability, :stock_qty, :weight, :price, :recommended, :on_sale, :sale_price, :discount, :block_qty, :sold, :available_price, :status, :tax_amount, :price_including_tax, :tax_id, :brand_id, :trending
    
    attribute :tags do |object|
      object.tags.select(:id, :name)
    end

    attribute :category do |object|
      sub_categories = object.sub_categories.select(:id, :name, :disabled, :category_id)
      if sub_categories.present?
        {
          id: sub_categories.first.category.id,
          name: sub_categories.first.category.name,
          sub_categories: sub_categories 
        }
      end
    end

    # attribute :subscriptions do |object|
    #   object.catalogue_subscriptions.select(:id, :subscription_package, :subscription_period, :discount, :catalogue_id, :morning_slot, :evening_slot)
    # end

    attribute :catalogue_attachments do |object|
      object.attachments.select{ |attachment| attachment.image.attached? }.map do |attachment|
        attachment_hash(attachment, $hostname)
      end
    end
    
    attribute :catalogue_variants_attributes do |object|
      if object.catalogue_variants.exists?  
        object.catalogue_variants.map do |catalogue_variant|
          {
            id: catalogue_variant.id,
            price: catalogue_variant.price,
            stock_qty: catalogue_variant.stock_qty,
            on_sale: catalogue_variant.on_sale,
            sale_price: catalogue_variant.sale_price,
            discount_price: catalogue_variant.discount_price,
            tax_id: catalogue_variant.tax_id,
            length: catalogue_variant.length,
            breadth: catalogue_variant.breadth,
            height: catalogue_variant.height,
            block_qty: catalogue_variant.block_qty,
            is_default: catalogue_variant.is_default,
            catalogue_variant_properties_attributes: catalogue_variant.catalogue_variant_properties.map { |catalogue_variant_property| { id: catalogue_variant_property.id, variant_id: catalogue_variant_property.variant_id, variant_property_id: catalogue_variant_property.variant_property_id } }, 
            catalogue_variant_attachments: catalogue_variant.attachments.select{ |attachment| attachment.image.attached? }.map { |attachment| attachment_hash(attachment, $hostname) }
          }
        end
      end
    end

  end
end
