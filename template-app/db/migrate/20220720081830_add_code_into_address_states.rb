class AddCodeIntoAddressStates < ActiveRecord::Migration[6.0]
  def change
    add_column :address_states, :code, :string
  end
end
