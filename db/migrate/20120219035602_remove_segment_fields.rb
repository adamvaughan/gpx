class RemoveSegmentFields < ActiveRecord::Migration
  def change
    remove_column :segments, :average_active_pace
    remove_column :segments, :average_active_speed
  end
end
