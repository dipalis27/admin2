module BxBlockCourse
  class Quiz < ApplicationRecord
    belongs_to :modulee, class_name: "BxBlockCourse::Modulee"
  end
end