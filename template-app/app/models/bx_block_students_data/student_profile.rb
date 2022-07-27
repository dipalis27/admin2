module BxBlockStudentsData
  class StudentProfile < BxBlockStudentsData::ApplicationRecord
    self.table_name = :student_profiles
    
    validates :student_email, :presence => true, :uniqueness => true,
                      :format => {:with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\Z/i}

    has_many :courses_student_profiles, class_name: 'BxBlockCourse::CourseStudentProfile'
    has_many :courses, through: :courses_student_profiles, class_name: "BxBlockCourse::CourseStudentProfile"

  end
end