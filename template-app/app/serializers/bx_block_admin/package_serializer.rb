module BxBlockAdmin
  class PackageSerializer < BuilderBase::BaseSerializer
    attributes :name, :length, :width, :height
  end
end