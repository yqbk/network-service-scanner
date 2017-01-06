class RemovePortIdAtFromHosts < ActiveRecord::Migration
  def change
    remove_column :hosts, :port_id, :integer
  end
end
