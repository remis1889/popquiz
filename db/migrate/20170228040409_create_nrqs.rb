class CreateNrqs < ActiveRecord::Migration[5.0]
  def change
    create_table :nrqs do |t|
      t.string :question_text, null: false
      t.boolean :required
      t.integer :min, null: false
      t.integer :max, null: false
      t.integer :survey_id

      t.timestamps
    end

    add_index(:nrqs, :survey_id)
  end
end
