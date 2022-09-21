class CreateSections < ActiveRecord::Migration[6.0]
  def change
    create_table :sections do |t|
      t.string :name
      t.integer :position
      t.string :component_name
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end
