class AddScannTypeToHosts < ActiveRecord::Migration
  def change
    add_column :hosts, :scann_type, :string
  end
end
