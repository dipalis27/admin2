class ELearningRenameColumnNameLesson < ActiveRecord::Migration[6.0]
  def change
    rename_column :lessons, :discription, :description
    add_column :lessons, :youtube_url, :string 
    add_column :lessons, :text, :string

  end
end
