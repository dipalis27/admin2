class CreateBxBlockLevelLevels < ActiveRecord::Migration[6.0]
  def change
    create_table :levels do |t|
      t.string :level_name
      t.timestamps
    end
  end
end
