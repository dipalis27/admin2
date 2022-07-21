module BxBlockOrderManagement
  class Country < BxBlockOrderManagement::ApplicationRecord
    self.table_name = :countries
    
    validates_presence_of :code, :name
    validates_uniqueness_of :code, :name

    has_many :address_states
    
  end
end
