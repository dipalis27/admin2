module BxBlockCourse
	class Question < ApplicationRecord
		self.table_name = :questions
		belongs_to :quiz , class_name: 'BxBlockCourse::Quiz'
		has_many :choices, class_name: 'BxBlockCourse::Choice' , dependent: :destroy
		accepts_nested_attributes_for :choices, allow_destroy: true
	end
end