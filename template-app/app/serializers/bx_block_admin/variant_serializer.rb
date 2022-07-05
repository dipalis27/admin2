
module BxBlockAdmin
  class VariantSerializer < BuilderBase::BaseSerializer
    attributes :name

    attribute :variant_properties do |object|
      object.variant_properties.select(:id, :variant_id, :name)
    end
  end
end