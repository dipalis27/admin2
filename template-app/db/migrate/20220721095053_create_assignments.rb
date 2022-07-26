class CreateAssignments < ActiveRecord::Migration[6.0]
  def change
    create_table :assignments do |t|
      t.string :title
      t.string :description
      t.string :select_type
      t.references :lesson, null: false, foreign_key: true
      t.boolean :make_this_a_prerequisite, :default => false
      t.boolean :enable_discussions_for_this_lesson , :default => false
      t.boolean :status , :default => false
      t.timestamps
    end
  end
end
