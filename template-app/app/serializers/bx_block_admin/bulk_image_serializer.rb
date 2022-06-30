module BxBlockAdmin
  class BulkImageSerializer < BuilderBase::BaseSerializer
  	attribute :id, :created_at, :updated_at

  	attribute :url do |object|
      $hostname + Rails.application.routes.url_helpers.rails_blob_url(object.image, only_path: true) if object.image.attached?
    end
  end
end
