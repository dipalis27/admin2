class CreateBxBlockCourseCourseInstructors < ActiveRecord::Migration[6.0]
  def change
    create_table :course_instructors do |t|
      t.integer :course_id
      t.integer :instructor_id
      t.timestamps
    end
  end
end
