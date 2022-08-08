class AddTimestampsToStudentProfile < ActiveRecord::Migration[6.0]
  def change
    change_table :student_profiles do |t|
      t.timestamps
    end
  end
end