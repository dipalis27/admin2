class CreateStudentProfile < ActiveRecord::Migration[6.0]
  def change
    create_table :student_profiles do |t|
      t.string :student_name
      t.string :student_email
      t.integer :level, default: 0
    end
  end
end
