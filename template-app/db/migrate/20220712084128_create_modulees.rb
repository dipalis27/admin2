class CreateModulees < ActiveRecord::Migration[6.0]
  def change
    create_table :modulees do |t|
       t.string :module_title
      t.references :course, null: false, foreign_key: true
      t.timestamps
      
    end
  end
end
