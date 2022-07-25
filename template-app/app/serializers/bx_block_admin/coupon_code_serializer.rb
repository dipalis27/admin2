module BxBlockAdmin
  class CouponCodeSerializer < BuilderBase::BaseSerializer
    attributes :id, :title, :description, :code, :discount_type, :discount, :valid_from,
      :valid_to, :min_cart_value, :max_cart_value, :limit
  end
end
