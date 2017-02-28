class CreateResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :responses do |t|
      t.integer :survey_id

      t.timestamps
    end

    add_index(:responses, :survey_id)
  end
end
