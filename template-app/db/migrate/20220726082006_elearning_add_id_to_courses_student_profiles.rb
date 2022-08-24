class ElearningAddIdToCoursesStudentProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :courses_student_profiles, :id, :primary_key
  end
end
