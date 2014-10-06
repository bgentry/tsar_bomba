class AddProviderRegionToFleet < ActiveRecord::Migration
  def change
    add_column :fleets, :provider_region, :string
  end
end
