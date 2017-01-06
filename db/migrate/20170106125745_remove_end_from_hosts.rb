class RemoveEndFromHosts < ActiveRecord::Migration
  def change
    remove_column :hosts, :end, :datetime
  end
end
