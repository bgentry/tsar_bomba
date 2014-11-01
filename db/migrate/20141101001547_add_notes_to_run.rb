class AddNotesToRun < ActiveRecord::Migration
  def change
    add_column :runs, :notes, :text
  end
end
