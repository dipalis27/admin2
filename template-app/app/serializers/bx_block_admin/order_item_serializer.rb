module BxBlockAdmin
  class OrderItemSerializer < BuilderBase::BaseSerializer
    extend AttachmentHelper
    attributes :id, :quantity, :unit_price, :total_price

    attribute :catalogue do |object|
      BxBlockAdmin::CatalogueSerializer.new(object.catalogue)
    end

    attribute :catalogue_variants do |object|
      variants = []
      if object.catalogue_variant.present?
        object.catalogue_variant.catalogue_variant_properties.each do |cvp|
          variant = {}
          variant[cvp.variant.name.to_s.to_sym] = cvp.variant_property.name
          variants << variant
        end
      end
      variants
    end

    attribute :catalogue_variant_attachment do |object|
      if object.catalogue_variant.present?
        object.catalogue_variant.attachments.select{ |attachment| attachment.image.attached? }.map { |attachment| attachment_hash(attachment, $hostname) }
      end
    end
  end
end
