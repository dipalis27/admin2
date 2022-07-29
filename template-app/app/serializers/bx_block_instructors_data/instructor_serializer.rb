module BxBlockInstructorsData
  class InstructorSerializer < BuilderBase::BaseSerializer
    attributes *[ 
      :instructor_name,
      :email
    ]

    attribute :image do |object, params|
      host = params[:host] || ''

      if object.image.attached?
        {
          id: object.image.id,
          url: host + Rails.application.routes.url_helpers.rails_blob_url(
            object.image, only_path: true
          )
        }
      end
    end

    attribute :courses do |object, params|
      BxBlockCourse::CourseSerializer.new(object.courses, { params: params })
    end

    attribute :private_courses do |object|
      object.courses
    end
  end
end
