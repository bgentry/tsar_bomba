class CreateInstances < ActiveRecord::Migration
  def change
    create_table :instances do |t|
      t.integer :fleet_id
      t.string :provider_id
      t.string :state

      t.timestamps null: false
    end

    add_foreign_key :instances, :fleets
  end
end
