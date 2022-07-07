module BxBlockAdmin
  class SubCategorySerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :disabled, :created_at, :updated_at

    attribute :image do |object|
      $hostname + Rails.application.routes.url_helpers.rails_blob_url(object.image, only_path: true) if object.image.attached?
    end
    
  end
end
