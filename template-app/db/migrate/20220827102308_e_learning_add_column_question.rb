class ELearningAddColumnQuestion < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :description, :string
  end
end
