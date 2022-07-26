module BxBlockStudentsData
  class StudentSerializer < BuilderBase::BaseSerializer
    attributes *[ 
      :student_name,
      :student_email,
      :level
    ]

    attribute :courses do |object, params|
      BxBlockCourse::CourseSerializer.new(object.courses, { params: params })
    end

    attribute :private_courses do |object|
      object.courses
    end
  end
end
