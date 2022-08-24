module BxBlockOrderManagement
  class AddressState < BxBlockOrderManagement::ApplicationRecord
    self.table_name = :address_states
    belongs_to :country, optional: true
    has_many :cities
  end
end
