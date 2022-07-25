module BxBlockOrderManagement
  class Currency < BxBlockOrderManagement::ApplicationRecord
    self.table_name = :currencies

    COUNTRY_SYMBOLS = { in: ['INR', '₹'], gb: ['GBP', '£'], us: ['USD', '$'] }.with_indifferent_access
    
    validates :name, :symbol, presence: true, uniqueness: true

    belongs_to :country
  end
end
