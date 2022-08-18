module BxBlockShippingCharge
  class ShippingCharge < BxBlockShippingCharge::ApplicationRecord
    self.table_name = :shipping_charges

    validates_presence_of :charge, :below, if: :is_free_shipping?
    
    before_save :set_charge
    after_commit :update_onboarding_step

    private

    def update_onboarding_step
      step_update_service = BxBlockAdmin::UpdateStepCompletion.new('shipping', self.class.to_s)
      step_update_service.call
    end

    def is_free_shipping?
      !(self.free_shipping)
    end

    def set_charge
      if self.free_shipping
        self.below = 0.0
        self.charge = 0.0
      end
    end
  end
end
