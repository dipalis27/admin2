
module BxBlockAdmin
  class VariantSerializer < BuilderBase::BaseSerializer
    attributes :name

    attribute :variant_properties do |object|
      object.variant_properties.map{ |variant_property| {id: variant_property.id, variant_id: variant_property.variant_id, variant_property_id: variant_property.id, name: variant_property.name } }
    end
  end
end