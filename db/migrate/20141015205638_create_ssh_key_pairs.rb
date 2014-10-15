class CreateSshKeyPairs < ActiveRecord::Migration
  def change
    create_table :ssh_key_pairs do |t|
      t.text :private_key, null: false

      t.timestamps null: false
    end
  end
end
