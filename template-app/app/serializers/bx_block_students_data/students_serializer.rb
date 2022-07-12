module BxBlockStudentsData
  class StudentsSerializer < BuilderBase::BaseSerializer
    attributes *[ 
      :student_name,
      :student_email,
      :level
    ]
  end
end
