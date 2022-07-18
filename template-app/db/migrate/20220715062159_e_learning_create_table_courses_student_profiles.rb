class ELearningCreateTableCoursesStudentProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :courses_student_profiles, id: false do |t|
      t.belongs_to :student_profile
      t.belongs_to :course
    end
  end
end
