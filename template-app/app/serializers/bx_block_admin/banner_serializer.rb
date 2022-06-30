module BxBlockAdmin

  class BannerSerializer < BuilderBase::BaseSerializer
    attributes :id, :banner_position, :web_banner
    attribute :attachments do |object|
      if object.attachments.present?
        BxBlockAdmin::AttachmentSerializer.new(object.attachments)
      else
        []
      end
    end
  end
  
end