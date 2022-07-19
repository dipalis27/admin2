module BxBlockCourse
	class Lesson < ApplicationRecord
		belongs_to :modulee, class_name: "BxBlockCourse::Modulee", dependent: :destroy
        has_one_attached :pdf
        validates :select_type , :presence => true
        enum select_type: [:youtube_url, :pdf , :text]
	end
end
