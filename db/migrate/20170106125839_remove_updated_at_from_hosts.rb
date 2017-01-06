class RemoveUpdatedAtFromHosts < ActiveRecord::Migration
  def change
    remove_column :hosts, :updated_at, :datetime
  end
end
