module BxBlockStoreProfile
  class Section < BxBlockStoreProfile::ApplicationRecord
    self.table_name = :sections
    validates_presence_of :component_name, :name, :position
    validates :position, numericality: {greater_than: 0}
  end
end
