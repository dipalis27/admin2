module BxBlockAdmin
  class SectionSerializer < BuilderBase::BaseSerializer
    attributes :id, :position, :name, :component_name, :is_active
  end
end
