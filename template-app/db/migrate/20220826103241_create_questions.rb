class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.string :question_title
      t.references :quiz

      t.timestamps
    end
  end
end
