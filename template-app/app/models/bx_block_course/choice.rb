module BxBlockCourse
	class Choice < ApplicationRecord
		self.table_name = :choices
		belongs_to :question, class_name: 'BxBlockCourse::Question'
	end
end
