class ELearningRenameColumnNameLesson < ActiveRecord::Migration[6.0]
  def change
    rename_column :lessons, :discription, :description
    add_column :lessons, :youtube_url, :string 
    add_column :lessons, :text, :string
    add_column :lessons, :title, :string 
    add_column :lessons, :content, :string
    add_column :lessons, :make_this_a_prerequisite, :boolean, :default => false
    add_column :lessons, :enable_discussion_for_this_lesson, :boolean, :default => false
  end
end
