module BxBlockOrderManagement
  class City < BxBlockOrderManagement::ApplicationRecord
    self.table_name = :cities
    validates_uniqueness_of :name, scope: :address_state_id
    
    belongs_to :address_state
  end
end
