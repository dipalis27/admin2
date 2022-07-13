module BxBlockCourse
	class Lesson < ApplicationRecord
		belongs_to :modulee, class_name: "BxBlockCourse::Modulee", dependent: :destroy
		has_one_attached :vedio
		
		enum select_type: ['vedio' , 'pdf']

	end
end
