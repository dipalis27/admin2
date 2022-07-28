module BxBlockAdmin
  class ZipcodeSerializer < BuilderBase::BaseSerializer
    attributes :id, :code, :activated, :charge, :price_less_than
  end
end
