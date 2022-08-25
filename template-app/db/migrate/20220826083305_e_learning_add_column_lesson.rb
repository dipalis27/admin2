class ELearningAddColumnLesson < ActiveRecord::Migration[6.0]
  def change
    add_column :lessons, :title, :string 
    add_column :lessons, :content, :string
    add_column :lessons, :make_this_a_prerequisite, :boolean, :default => false
    add_column :lessons, :enable_discussion_for_this_lesson, :boolean, :default => false
  end
end
