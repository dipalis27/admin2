module BxBlockAdmin
  class ShippingChargeSerializer < BuilderBase::BaseSerializer
    attributes :id, :below, :charge, :free_shipping
  end
end
