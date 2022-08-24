module BxBlockFileUpload
  class AttachmentSerializer < BuilderBase::BaseSerializer
    attributes :attachable_type, :attachable_id, :position, :is_default

    attribute :url do |object|
      url_for(object.image) if object.image.attached?
    end

    attribute :url_link do |object|
      object.url
    end
  end
end
