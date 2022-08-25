class CreateShipRocketRaws < ActiveRecord::Migration[6.0]
  def change
    create_table :ship_rocket_raws do |t|
      t.json :payload
      t.string :shipment_status
      t.timestamps
    end
  end
end
