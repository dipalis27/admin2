
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

module BxBlockAdmin
  class CatalogueSerializer < BuilderBase::BaseSerializer
    attributes :name, :sku, :description, :manufacture_date, :length, :breadth, :height, :availability, :stock_qty, :weight, :price, :recommended, :on_sale, :sale_price, :discount, :block_qty, :sold, :available_price, :status, :tax_amount, :price_including_tax,  :catalogue_variants
    
    attribute :tags do |object|
      object.tags.select(:id, :name)
    end

    attribute :brand do |object|
      object.brand&.name
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

    attribute :subscriptions do |object|
      object.catalogue_subscriptions.select(:id, :subscription_package, :subscription_period, :discount, :catalogue_id, :morning_slot, :evening_slot)
    end

    attribute :attachments do |object|
      if object.attachments.present?
        BxBlockAdmin::AttachmentSerializer.new(object.attachments)
      end
    end
    
  end
end
