class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|
      t.integer :scan_id
      t.datetime :start
      t.datetime :end
      t.string :IP
      t.references :port, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
