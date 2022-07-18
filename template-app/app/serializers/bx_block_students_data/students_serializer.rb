module BxBlockStudentsData
  class StudentsSerializer < BuilderBase::BaseSerializer
    attributes *[ 
      :student_name,
      :student_email,
      :level
    ]

    attribute :courses do |object, params|
      BxBlockCourse::CourseSerializer.new(object.courses, { params: params })
    end
  end
end
