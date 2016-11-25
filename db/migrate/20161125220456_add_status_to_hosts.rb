class AddStatusToHosts < ActiveRecord::Migration
  def change
    add_column :hosts, :status, :string
  end
end
