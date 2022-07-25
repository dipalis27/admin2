module BxBlockCourse
  class ModuleeSerializer< BuilderBase::BaseSerializer
    include JSONAPI::Serializer
    attributes *[
      :course_id,
      :module_title
    ] 

    attribute :lessons do |object, params|
      if object.present?
        BxBlockCourse::LessonSerializer.new(
          object.lessons, { params: params }
        ).serializable_hash[:data]
      end
    end
  end
end
