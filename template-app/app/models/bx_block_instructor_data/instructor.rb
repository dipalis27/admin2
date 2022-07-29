module BxBlockInstructorData
  class Instructor < BxBlockInstructorData::ApplicationRecord
    self.table_name = :instructors
    has_one_attached :image
    validates :instructor_name, :presence => true
    validates :email, :presence => true, :uniqueness => true,
                      :format => {:with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\Z/i}

    has_many :courses_instructors, class_name: 'BxBlockCourse::CourseInstructor'
    has_many :courses, through: :courses_instructors, class_name: "BxBlockCourse::CourseInstructor"
  end
end