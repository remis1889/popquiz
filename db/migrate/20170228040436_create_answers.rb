class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.integer :question_id
      t.string :question_type
      t.integer :answer_entry
      t.integer :response_id

      t.timestamps
    end

    add_index(:answers, :response_id)
    add_index(:answers, [:question_id, :question_type])
  end
end
