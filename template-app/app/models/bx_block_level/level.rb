module BxBlockLevel
  class Level < BxBlockLevel::ApplicationRecord
    self.table_name = :levels
    
    validates :level_name, :presence => true, :uniqueness => true
    
    # has_many :courses_student_profiles, class_name: 'BxBlockCourse::CourseStudentProfile'
    # has_many :courses, through: :courses_student_profiles, class_name: "BxBlockCourse::CourseStudentProfile"

  end
end