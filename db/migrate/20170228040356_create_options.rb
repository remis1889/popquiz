class CreateOptions < ActiveRecord::Migration[5.0]
  def change
    create_table :options do |t|
      t.string :option_text, null: false
      t.integer :mcq_id

      t.timestamps
    end
    add_index(:options, :mcq_id)
  end
end
