class RemoveStartFromHosts < ActiveRecord::Migration
  def change
    remove_column :hosts, :start, :datetime
  end
end
