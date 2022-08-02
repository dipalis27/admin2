module BxBlockCourse
  class Quiz < ApplicationRecord
    self.table_name = :quizzes
    belongs_to :modulee, class_name: "BxBlockCourse::Modulee"
    has_many :questions ,class_name: "BxBlockCourse::Question" , dependent: :destroy
    accepts_nested_attributes_for :questions, allow_destroy: true
  end
end