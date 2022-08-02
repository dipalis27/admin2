module BxBlockCourse
  class QuestionSerializer
    include JSONAPI::Serializer
  
     attributes *[
      :id, 
      :question_title,
      :description  
    ]

    attribute :choices do |object, params|
        object.choices   
    end
  end
end
