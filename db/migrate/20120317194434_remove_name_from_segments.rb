class RemoveNameFromSegments < ActiveRecord::Migration
  def change
    remove_column :segments, :name
  end
end
