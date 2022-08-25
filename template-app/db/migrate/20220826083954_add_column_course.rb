class AddColumnCourse < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :discription, :string
  end
end
