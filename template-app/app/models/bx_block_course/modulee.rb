module BxBlockCourse
  class Modulee < ApplicationRecord
    self.table_name = :modulees
    belongs_to :course, class_name: "BxBlockCourse::Course"
    has_many :lessons, class_name: "BxBlockCourse::Lesson" ,dependent: :destroy
    has_many :quizzes, class_name: "BxBlockCourse::Quiz" ,dependent: :destroy 
    has_many :assignments , class_name: "BxBlockCourse::Assignment" ,dependent: :destroy
  end
end
