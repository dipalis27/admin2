module BxBlockAdmin
  class ChangeCategoriesSubCategories
    include BxBlockAdmin::ModelUtilities

    def initialize(category_params)
      @categories = []
      @errors = []
      @category_params = category_params
    end

    def call
      @category_params.each do |cat_par|
        if cat_par['id'].present?
          update_category_sub_categories(cat_par)
        else
          create_category_sub_categories(cat_par)
        end
      end
      [@categories.map(&:reload), @errors.flatten]
    end

    def create_category_sub_categories(cat_par)
      category = BxBlockCategoriesSubCategories::Category.new(name: cat_par['name'])
      category = change_object_attributes(category, cat_par['disabled'], cat_par['image'])
      cat_par['sub_categories_attributes']&.each do |sub_cat_par|
        category = add_sub_category(category, sub_cat_par)
      end

      if category.save
        @categories << category
      else
        @errors.push(category.errors.full_messages)
      end
    end

    def update_category_sub_categories(cat_par)
      category = BxBlockCategoriesSubCategories::Category.find_by_id(cat_par['id'].to_i)
      return false if category.nil?
      category.destroy and return if cat_par['_destroy'].present? && cat_par['_destroy'].to_i == 1

      category.name = cat_par['name'] if cat_par['name'].present?
      category = change_object_attributes(category, cat_par['disabled'], cat_par['image'])
      cat_par['sub_categories_attributes']&.each do |sub_cat_par|
        if sub_cat_par['id'].present?
          update_sub_category(category, sub_cat_par)
        else
          create_sub_category(category, sub_cat_par)
        end
      end

      if category.save
        @categories << category
      else
        @errors.push(category.errors.full_messages)
      end
    end

    def add_sub_category(category, sub_cat_par)
      sub_category = category.sub_categories.new(name: sub_cat_par['name'])
      change_object_attributes(sub_category, sub_cat_par['disabled'], sub_cat_par['image'])
      category
    end

    def create_sub_category(category, sub_cat_par)
      return if category.sub_categories.exists?(name: sub_cat_par['name'])
      sub_category = category.sub_categories.new(name: sub_cat_par['name'])
      sub_category = change_object_attributes(sub_category, sub_cat_par['disabled'], sub_cat_par['image'])
      @errors.push(sub_category.errors.full_messages) unless sub_category.save
    end

    def update_sub_category(category, sub_cat_par)
      sub_category = category.sub_categories.find_by_id(sub_cat_par['id'].to_i)
      return unless sub_category.present?
      sub_category.destroy and return if sub_cat_par['_destroy'].present? && sub_cat_par['_destroy'].to_i == 1

      sub_category.name = sub_cat_par['name'] if sub_cat_par['name'].present?
      sub_category = change_object_attributes(sub_category, sub_cat_par['disabled'], sub_cat_par['image'])
      @errors.push(sub_category.errors.full_messages) unless sub_category.save
    end

    def change_object_attributes(object, disabled, base64)
      object.disabled = disabled if disabled.present?
      object = attach_image(object, base64, 'image') if base64.present?
      object
    end
  end
end
