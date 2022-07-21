class CreateCurrencies < ActiveRecord::Migration[6.0]
  def change
    create_table :currencies do |t|
      t.string :name
      t.string :symbol

      t.references :country, null: false, foreign_key: true
      t.timestamps
    end
  end
end
