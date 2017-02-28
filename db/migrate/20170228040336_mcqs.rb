class Mcqs < ActiveRecord::Migration[5.0]
  def change
    create_table :mcqs do |t|
      t.string :question_text, null: false
      t.boolean :required
      t.boolean :multiselect
      t.integer :survey_id
      t.boolean :shuffle_options, default: false

      t.timestamps
    end
    add_index(:mcqs, :survey_id)
  end
end
