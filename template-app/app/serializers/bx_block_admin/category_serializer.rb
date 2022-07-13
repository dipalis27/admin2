module BxBlockAdmin
  class CategorySerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :disabled, :created_at, :updated_at

    attribute :image do |object|
      $hostname + Rails.application.routes.url_helpers.rails_blob_url(object.image, only_path: true) if object.image.attached?
    end

    attribute :sub_categories do |object, params|
      BxBlockAdmin::SubCategorySerializer.new(object.sub_categories)
    end
  end
end
