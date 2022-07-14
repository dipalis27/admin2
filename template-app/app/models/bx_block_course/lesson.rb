module BxBlockCourse
	class Lesson < ApplicationRecord
		belongs_to :modulee, class_name: "BxBlockCourse::Modulee", dependent: :destroy

	end
end
