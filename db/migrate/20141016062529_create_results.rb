class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :run_id
      t.integer :instance_id
      t.json :raw_data, null: false

      t.timestamps null: false
    end

    add_foreign_key :results, :runs, on_delete: :cascade
  end
end
