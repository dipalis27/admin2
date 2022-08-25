class AddCountruyIdIntoAddressStates < ActiveRecord::Migration[6.0]
  def change
    add_column :address_states, :country_id, :integer
    add_index :address_states, :country_id
  end
end
