class RemoveLatitudeFromSegments < ActiveRecord::Migration
  def change
    remove_column :segments, :latitude
  end
end
