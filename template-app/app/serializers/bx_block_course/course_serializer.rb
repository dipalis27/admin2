module BxBlockCourse
  class CourseSerializer < BuilderBase::BaseSerializer
     attributes *[
      :course_name
    ]
  end
end