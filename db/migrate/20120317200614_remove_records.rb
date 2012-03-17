class RemoveRecords < ActiveRecord::Migration
  def change
    drop_table :records
  end
end
