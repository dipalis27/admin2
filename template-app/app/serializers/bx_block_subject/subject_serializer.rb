module BxBlockSubject
  class SubjectSerializer
    include JSONAPI::Serializer
    attributes *[
      :subject_name
    ]
  end
end
