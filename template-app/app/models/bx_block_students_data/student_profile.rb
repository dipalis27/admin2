module BxBlockStudentsData
  class StudentProfile < BxBlockStudentsData::ApplicationRecord
    self.table_name = :student_profiles
    
    validates :student_email, :presence => true, :uniqueness => true,
                      :format => {:with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\Z/i}

    has_and_belongs_to_many :courses, class_name: "BxBlockCourse::Course"

  end
end