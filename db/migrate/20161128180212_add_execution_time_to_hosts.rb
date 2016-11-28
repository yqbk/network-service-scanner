class AddExecutionTimeToHosts < ActiveRecord::Migration
  def change
    add_column :hosts, :scann_time, :string
  end
end
