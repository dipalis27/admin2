class ELearningToAddModuleIdQuiz < ActiveRecord::Migration[6.0]
  def change
     add_reference :quizzes, :modulee , foreign_key: true
     add_reference :assignments , :modulee , foreign_key: true
     remove_column :quizzes , :lesson_id
     remove_column :assignments , :lesson_id   
  end
end
