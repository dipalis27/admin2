class CreateChoices < ActiveRecord::Migration[6.0]
  def change
    create_table :choices do |t|
      t.string :choice_title
      t.boolean :is_correct_answer
      t.references :question
      t.timestamps
    end
  end
end
