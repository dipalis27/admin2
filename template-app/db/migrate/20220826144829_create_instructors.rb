class CreateInstructors < ActiveRecord::Migration[6.0]
  def change
    create_table :instructors do |t|
      t.string :instructor_name
      t.string :email
      t.timestamps
    end
  end
end
