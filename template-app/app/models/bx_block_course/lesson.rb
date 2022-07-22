module BxBlockCourse
	class Lesson < ApplicationRecord
		belongs_to :modulee, class_name: "BxBlockCourse::Modulee"
		has_many :assignments ,class_name: "BxBlockCourse::Assignment", dependent: :destroy
		has_many :quizzes ,class_name: "BxBlockCourse::Quiz", dependent: :destroy
        has_one_attached :pdf
        # validates :select_type , :presence => true
        # enum select_type: [:youtube_url, :pdf , :text]
	end
end
