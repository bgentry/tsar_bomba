class CreateFleets < ActiveRecord::Migration
  def change
    create_table :fleets do |t|
      t.string :instance_type, null: false
      t.integer :instance_count, null: false

      t.timestamps null: false
    end
  end
end
