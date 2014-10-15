class AddDnsNameToInstance < ActiveRecord::Migration
  def change
    add_column :instances, :dns_name, :string
  end
end
