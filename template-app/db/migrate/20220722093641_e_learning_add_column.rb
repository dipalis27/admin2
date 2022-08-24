class ELearningAddColumn < ActiveRecord::Migration[6.0]
  def change
    add_column :lessons, :status, :boolean
  end
end
