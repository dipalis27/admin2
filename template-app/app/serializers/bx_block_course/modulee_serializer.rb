module BxBlockCourse
  class ModuleeSerializer< BuilderBase::BaseSerializer
    include JSONAPI::Serializer
    attributes *[
      :course_id,
      :module_title
    ] 
  end
end
