class CreateSurveys < ActiveRecord::Migration[5.0]
  def change
    create_table :surveys do |t|
      t.string :title, unique: true, null: false
      t.text :description
      t.datetime :published_on
      t.boolean :shuffle_questions, default: false
      t.integer :responses_count, default: 0, null: false
      t.timestamps
    end

    add_index(:surveys, :title, unique: true)
  end
end
