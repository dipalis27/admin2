module BxBlockCourse
	class Course < ApplicationRecord
     	self.table_name = :courses
		has_many :modulees, class_name: "BxBlockCourse::Modulee", dependent: :destroy
	end
end
