module BxBlockCourse
  class QuestionSerializer
    include JSONAPI::Serializer
  
     attributes *[
      :id, 
      :question_title,
      :description  
    ]

    attribute :choices_attributes do |object, params|
        object.choices   
    end
  end
end
