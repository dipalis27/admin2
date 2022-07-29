module BxBlockAdmin
  class AttachmentSerializer < BuilderBase::BaseSerializer
    attributes :id, :attachable_type, :attachable_id, :position, :is_default

    attribute :url do |object|
      $hostname + Rails.application.routes.url_helpers.rails_blob_url(object.image, only_path: true) if object.image.present? && object.image.attached?
    end

    attribute :url_link do |object|
      object.url
    end

    attribute :is_present? do |object|
      object.url_type.present?
    end

    attribute :url_id do |object|
      if object.url_type.present?
        if object.url_id.present? && object.url_type == 'product'
          object.url_id
        else
          object.category_url_id
        end
      end
    end

    attribute :url_type do |object|
      if object.url_type.present?
        object.url_type
      end
    end
    
  end
end