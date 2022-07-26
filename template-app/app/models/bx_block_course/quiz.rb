module BxBlockCourse
  class Quiz < ApplicationRecord
    belongs_to :lesson
  end
end