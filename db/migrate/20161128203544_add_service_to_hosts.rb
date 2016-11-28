class AddServiceToHosts < ActiveRecord::Migration
  def change
    add_column :hosts, :service, :string
  end
end
