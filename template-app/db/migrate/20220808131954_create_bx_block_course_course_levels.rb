class CreateBxBlockCourseCourseLevels < ActiveRecord::Migration[6.0]
  def change
    create_table :course_levels do |t|
      t.integer :course_id
      t.integer :level_id
      t.timestamps
    end
  end
end
