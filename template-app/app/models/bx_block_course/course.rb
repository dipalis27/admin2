module BxBlockCourse
	class Course < ApplicationRecord
     	self.table_name = :courses
		has_many :modulees, class_name: "BxBlockCourse::Modulee", dependent: :destroy
		has_and_belongs_to_many :student_profiles, class_name: "BxBlockStudentsData::StudentProfile"
	end
end
