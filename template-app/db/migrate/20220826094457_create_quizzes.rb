class CreateQuizzes < ActiveRecord::Migration[6.0]
  def change
    create_table :quizzes do |t|
      t.string :select_type
      t.string :quiz_title
      t.string :question
      t.string :question_type
      t.string :description
      t.string :choise
      t.boolean :make_this_a_prerequisite, :default => false
      t.boolean :gradeable , :default => false
      t.boolean :enable_discussions_for_this_lesson , :default => false
      t.boolean :status , :default => false
      t.boolean :correct_answer , :default => false
      t.references :lesson, null: false, foreign_key: true

      t.timestamps
    end
  end
end
