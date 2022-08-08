module BxBlockOrderManagement
  class Package < BxBlockOrderManagement::ApplicationRecord
    self.table_name = :packages

    ## Assoications
    has_many :orders

    ## Callbacks
    before_update :check_orders
    before_destroy :check_orders

    ## Validations
    validates_presence_of :name, :length, :width, :height
    validates :length, :width, :height, numericality: true

    def check_orders
      if orders.exists?
        errors.add(:base, "Orders exists with package.")
      end
    end
  end
end