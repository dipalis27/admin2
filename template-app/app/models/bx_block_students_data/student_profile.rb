module BxBlockStudentsData
  class StudentProfile < BxBlockStudentsData::ApplicationRecord
    self.table_name = :student_profiles
    
    validates :student_name, :presence => true
    validates :student_email, :presence => true, :uniqueness => true,
                      :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}

  end
end
