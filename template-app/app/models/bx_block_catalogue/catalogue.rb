# == Schema Information
#
# Table name: catalogues
#
#  id               :bigint           not null, primary key
#  category_id      :bigint           not null
#  sub_category_id  :bigint           not null
#  brand_id         :bigint
#  name             :string
#  sku              :string
#  description      :string
#  manufacture_date :datetime
#  length           :float
#  breadth          :float
#  height           :float
#  availability     :integer
#  stock_qty        :integer
#  weight           :decimal(, )
#  price            :float
#  recommended      :boolean
#  on_sale          :boolean
#  sale_price       :decimal(, )
#  discount         :decimal(, )
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  block_qty        :integer
#  sold             :integer          default(0)
#
module BxBlockCatalogue
  class Catalogue < BxBlockCatalogue::ApplicationRecord
    attr_accessor :cart_quantity
    # attr_accessor :cropped_image

    PAGE = 1
    PER_PAGE = 10
    ATTACHMENT_SIZE = { min_width: 374, max_width: 400, min_height: 400, max_height: 800 }

    self.table_name = :catalogues

    enum availability: %i[in_stock out_of_stock]
    enum status: %i[active draft]

    # Associations
    belongs_to :brand, optional: true
    belongs_to  :tax, class_name: "BxBlockOrderManagement::Tax", optional: true

    has_and_belongs_to_many :sub_categories,
                            class_name: 'BxBlockCategoriesSubCategories::SubCategory',
                            join_table: 'catalogues_sub_categories', foreign_key: 'catalogue_id'
    has_many :order_items, class_name: "BxBlockOrderManagement::OrderItem"
    has_many :orders,
             class_name: "BxBlockOrderManagement::Order", through: :order_items

    has_many :reviews, dependent: :destroy
    has_many :catalogue_variants,
             class_name: "BxBlockCatalogue::CatalogueVariant", dependent: :destroy
    has_many :product_notifies, class_name: "BxBlockCatalogue::ProductNotify", dependent: :destroy
    has_and_belongs_to_many :tags, join_table: :catalogues_tags
    has_and_belongs_to_many :bulk_images, class_name: 'BxBlockCatalogue::BulkImage',
      join_table: 'catalogues_bulk_images', optional: true

    # has_many_attached :images, dependent: :destroy
    has_many :attachments, as: :attachable, class_name: "BxBlockFileUpload::Attachment", dependent: :destroy
    has_many    :catalogue_subscriptions, dependent: :destroy

    # Nested attributes
    accepts_nested_attributes_for :catalogue_subscriptions, allow_destroy: true
    accepts_nested_attributes_for :attachments, allow_destroy: true
    accepts_nested_attributes_for :catalogue_variants, allow_destroy: true, reject_if: :all_blank
    accepts_nested_attributes_for :catalogue_variants, allow_destroy: true
    accepts_nested_attributes_for :tags

    # Validations
    validates :name, :price, :stock_qty, presence: true
    validates_uniqueness_of :sku, :allow_blank => true
    validates_presence_of :sale_price, if: Proc.new { |a| a.on_sale? }
    # validate :has_catalogue_variants
    validates :weight, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10}

    # Custom validation
    validate :update_availability
    validate :has_images, on: :create, if: -> { self.active? }
    validate :has_remained_any_image_on_update, on: :update, if: -> { self.active? }
    validate :has_tax, if: -> { self.active? }
    validate :duplicate_variant
    validate :check_sale_price, :validate_manufacture_date

    # Callbacks
    before_create :track_event
    before_save :set_stock_qty, :check_product_quantity, :set_current_availablity,
                :calculate_tax_amount, :update_available_price
    before_update :update_orders
    after_save :add_system_sku, :update_default_variant, :inventory_low_stock_mailings
    after_save :remove_draft_products_from_cart, if: -> { self.draft? }
    after_destroy :destroy_wishlist_items

    # Scopes
    scope :latest, -> { order(created_at: :desc) }
    scope :latest_ten, -> { order(created_at: :desc).limit(10) }
    scope :popular, -> { order(sold: :desc) }
    scope :recommended, -> { where(recommended: true) }
    scope :discounted_items, -> { where(on_sale: true) }


    def duplicate_variant
      self.catalogue_variants.each do |variant|
        variant_properties = variant.catalogue_variant_properties
        unless variant_properties.length == variant_properties.map(&:variant_id).uniq.length
          self.errors.add(:variant, "can't have duplicate properties")
          return
        end
      end

      arr = []
      self.catalogue_variants.each_with_index do |variant, i|
        variant.catalogue_variant_properties.each{|a| arr << {variant: i+1, variant_id: a.variant_id, variant_property_id: a.variant_property_id}}
      end
      group = arr.group_by{|a| a[:variant]}

      group.each{|k,v| v.each{|_hash| _hash.delete(:variant)}}
      if group.values.combination(2).any? {|a, b| a == b }
        self.errors.add(:variant, "Two variant can't have similar properties")
      end

    end

    def track_event
      Analytics.track(user_id: ENV["HOST_URL"].split("-")[1],event: 'New Products Created')
    end

    def average_rating
      return 0 if reviews.where(is_published: true).size.zero?

      total_rating = 0
      reviews.where(is_published: true).each do |r|
        total_rating += r.rating
      end
      (total_rating.to_f / reviews.size.to_f).to_f.round(2)
    end

    def update_availability
      stock_qty.to_i < 1 ? self.availability = "out_of_stock" : self.availability = "in_stock"
    end

    def has_images
      errors.add(:base, 'must add at least one image / make product inactive') if self.attachments.blank? && Rails.env != 'test'
    end

    def has_remained_any_image_on_update
      attachments_to_delete = self.attachments.select{|att| att._destroy == true}
      persisted_obj = BxBlockCatalogue::Catalogue.find(self.id)
      remaining_attachments = persisted_obj.attachments.where.not(id: attachments_to_delete.pluck(:id))
      if remaining_attachments.count == 0
        errors.add(:base, 'must add at least one image') if self.attachments.blank? || self.attachments.any?{|att| att.cropped_image.blank?}
      end
    end

    # def has_catalogue_variants
    #   errors.add(
    #     :base, 'must add at least one product variant'
    #   ) unless self.catalogue_variants.present?
    # end

    def validate_manufacture_date
      return if manufacture_date.blank?
      if manufacture_date >= Date.today
        errors.add(:manufacture_date, "can't be future dates.")
      end
    end

    def check_sale_price
      if self.sale_price.present? && (self.sale_price.to_f > self.price.to_f)
        errors.add(:sale_price, 'can not be greater then price')
      end
    end

    def add_system_sku
      sku = Integer(self.sku) rescue nil
      update_column(:sku, format('COD%.7d', id)) if self.sku.blank? || sku.present?
    end

    def update_default_variant
      # return unless catalogue_variants.find_by(is_default: true)

      # catalogue_variants.first.update!(is_default: true)
    end

    def available_stock_quantity
      self.stock_qty.to_i - self.block_qty.to_i
    end

    def update_available_price
      self.available_price = self.on_sale == true ? self.sale_price : self.price
    end

    def set_stock_qty
      if catalogue_variants.present?
        stock_qty = catalogue_variants.map(&:stock_qty).sum
        self.stock_qty = stock_qty
      end
    end

    def check_product_quantity
      out_of_stock! if (stock_qty.present? && stock_qty.to_i - block_qty.to_i <= 1 && stock_qty.to_i < 1) && in_stock?
      in_stock! if (stock_qty.present? && stock_qty.to_i - block_qty.to_i >= 1) && out_of_stock?
    end

    def set_current_availablity
      available_in_stock = stock_qty.present? && self.available_stock_quantity >= 1
      self.availability = available_in_stock ? 'in_stock' : 'out_of_stock'
    end

    def calculate_tax_amount
      if self.catalogue_variants.blank?
        tax = self.tax
        return unless tax.present?
        price = self.sale_price.present? ? self.sale_price : self.price
        tax_value = (price.to_f * 100) / (100 + tax.tax_percentage.to_f)
        tax_charge = price - tax_value
        self.tax_amount = tax_charge.round(2)
        self.price_including_tax = price.to_f.round(2)
      end
    end

    def self.search(options = {})
      search_key = options.dig(:search)
      filters = options.dig(:filters)
      outer_condition_array = []
      subquery_condition_array = []
      if filters.present?
        filters.select{ |key,value| value.present? }.each do |column_name, value|
          case column_name.to_s
            when "status"
              status_enum_value = Catalogue.statuses[value.downcase]
              outer_condition_array << "catalogues.status = #{status_enum_value}"
            when "categories"
              if value.is_a?(Array)
                value.each do |each_value|
                  subquery_condition_array << "LOWER(categories.name) LIKE '%#{each_value.downcase}%' "
                end
              else
                subquery_condition_array << "LOWER(categories.name) LIKE '%#{value.downcase}%' "
              end
            when "sub_categories"
              if value.is_a?(Array)
                value.each do |each_value|
                  subquery_condition_array << "LOWER(sub_categories.name) LIKE '%#{each_value.downcase}%' "
                end
              else
                subquery_condition_array << "LOWER(sub_categories.name) LIKE '%#{value.downcase}%' "
              end
          end
        end
      end
      if search_key.present?
        search_key = search_key.downcase
        outer_condition_array << "LOWER(catalogues.name) LIKE '%#{search_key}%' "
        subquery_condition_array.push("LOWER(categories.name) LIKE '%#{search_key}%' ", "LOWER(sub_categories.name) LIKE '%#{search_key}%' ") 
      end
      if outer_condition_array.present?
        outer_condition_string = "WHERE " + outer_condition_array.join(" AND ")
      end
      if subquery_condition_array.present?
        subquery_condition_string = "WHERE "+ subquery_condition_array.join(" OR ")
        sub_query = " #{outer_condition_string.present? ? 'OR' : 'WHERE' } catalogues.id IN (
                      SELECT DISTINCT catalogue_id FROM 
                      (
                        SELECT csc.*, categories.name AS category_name, sub_categories.name AS sub_category_name FROM catalogues_sub_categories AS csc
                        INNER JOIN sub_categories on sub_categories.id = csc.sub_category_id
                        INNER JOIN categories on categories.id = sub_categories.category_id
                        #{subquery_condition_string}
                      ) AS catalogues_sub_categories
                    )"
      end
      condition_string = outer_condition_string.to_s + sub_query.to_s
      query = "SELECT * FROM catalogues
              #{condition_string}"
      BxBlockCatalogue::Catalogue.find_by_sql(query)
    end

    def self.generate_sample_csv
      csv_data = []
      variant_properties = []

      variants = BxBlockCatalogue::Variant.all.pluck(:name)
      BxBlockCatalogue::Variant.all.each do |variant|
        variant_properties.push(BxBlockCatalogue::VariantProperty.all.where(variant_id: variant.id).first.name)
      end

      cols = ["category", "sub_category", "brand", "tags", "name", "sku", "description", "manufacture_date", "length", "breadth", "height", "availability", "stock_qty", "weight", "price", "on_sale", "sale_price", "recommended", "discount", "block_qty", "tax", "variant_price", "variant_stock_qty", "variant_on_sale", "variant_sale_price", "variant_discount_price", "variant_length", "variant_breadth", "variant_height", "variant_block_qty", "variant_tax", "default"]
      variants.map { |name| cols << 'variant_' + name }.flatten
      csv_data << cols

      data = ["Category 1","Sub Category 1","Brand 1","Tag 1","Aspire","SKU834","acer description","26/02/21","12","13","14","in_stock","13","10","15000","FALSE","13500","TRUE","500","1","14.0","16000","4","FALSE","15500","","12","13","14","2","12.0","TRUE"]
      variant_properties.map { |name| data << name }.flatten
      csv_data << data

      csv_data
    end

    def destroy_wishlist_items
      BxBlockWishlist::WishlistItem.by_catalogue_id(self.id).destroy_all
    end

    private

    def has_tax
      errors.add(:base, 'must have a tax value') if self.tax.nil?
    end

    def inventory_low_stock_mailings
      unless self.new_record?
        if self.stock_qty.to_i <= 10 && self.stock_qty_changed?
          AdminUser.all.each do |admin|
            LowStockJob.perform_later($hostname, admin, self)
          end
        end  
      end
    end

    def remove_draft_products_from_cart
      (BxBlockOrderManagement::OrderItem.joins(:order).where("orders.status IN (?)",['in_cart', 'created']).where(catalogue: self)).or(BxBlockOrderManagement::OrderItem.joins(:order).where("orders.status IN (?)",['in_cart', 'created']).where(catalogue_variant: self.catalogue_variants)).destroy_all
    end

    def update_orders
      order_items = BxBlockOrderManagement::OrderItem.where(catalogue_id: self.id)
      BxBlockOrderManagement::UpdateCartValueOnCatalogueUpdate.new(order_items).call
    end
  end
end
