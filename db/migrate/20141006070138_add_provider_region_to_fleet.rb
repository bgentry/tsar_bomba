class AddProviderRegionToFleet < ActiveRecord::Migration
  def change
    add_column :fleets, :provider_region, :string, null: false, default: "us-east-1"
  end
end
