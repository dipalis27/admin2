class CreateLessons < ActiveRecord::Migration[6.0]
  def change
    create_table :lessons do |t|
      t.string :lesson_title
      t.string :discription
      t.string :select_type
      t.references :modulee, null: false, foreign_key: true
      t.timestamps
    end
  end
end
