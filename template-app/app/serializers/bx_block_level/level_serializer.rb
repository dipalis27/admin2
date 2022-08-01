module BxBlockLevel
  class LevelSerializer < BuilderBase::BaseSerializer
    attributes *[ 
      :level_name
    ]

    # attribute :courses do |object, params|
    #   BxBlockCourse::CourseSerializer.new(object.courses, { params: params })
    # end

    # attribute :private_courses do |object|
    #   object.courses
    # end
  end
end
