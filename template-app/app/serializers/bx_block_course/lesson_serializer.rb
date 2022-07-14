module BxBlockCourse
  class LessonSerializer < BuilderBase::BaseSerializer
    include JSONAPI::Serializer
    attributes *[
      :lesson_title,
      :discription,
    ]
  end
end