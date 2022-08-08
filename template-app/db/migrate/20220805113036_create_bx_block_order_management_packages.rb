class CreateBxBlockOrderManagementPackages < ActiveRecord::Migration[6.0]
  def change
    create_table :packages do |t|
      t.string :name
      t.float :length
      t.float :width
      t.float :height
      
      t.timestamps
    end
  end
end
