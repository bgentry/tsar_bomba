class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.integer :fleet_id
      t.string :target, null: false
      t.string :host_header
      t.integer :duration, null: false
      t.integer :rate, null: false
      t.string :state, null: false

      t.timestamps null: false
    end
  end
end
