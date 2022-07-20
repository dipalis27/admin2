class ELearningAddFieldToCourseTable < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :is_private, :boolean, default: false
  end
end
