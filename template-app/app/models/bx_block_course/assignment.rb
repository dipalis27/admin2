module BxBlockCourse
  class Assignment < ApplicationRecord
   belongs_to :modulee, class_name: "BxBlockCourse::Modulee" 
   has_one_attached :pdf
 end
end